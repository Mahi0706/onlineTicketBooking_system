package com.ticketbooking.service;

import com.ticketbooking.dto.*;
import com.ticketbooking.entity.*;
import com.ticketbooking.exception.BadRequestException;
import com.ticketbooking.exception.ResourceNotFoundException;
import com.ticketbooking.repository.*;
import com.ticketbooking.util.QRCodeGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class BookingService {
    @Autowired
    private BookingRepository bookingRepository;
    
    @Autowired
    private EventRepository eventRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private SeatRepository seatRepository;
    
    @Autowired
    private PromotionRepository promotionRepository;
    
    @Autowired
    private PaymentService paymentService;
    
    @Transactional
    public BookingResponse createBooking(BookingRequest request, Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
        
        Event event = eventRepository.findById(request.getEventId())
                .orElseThrow(() -> new ResourceNotFoundException("Event not found"));
        
        // Check if seats are available
        List<Seat> seats = seatRepository.findAllById(request.getSeatIds());
        if (seats.size() != request.getSeatIds().size()) {
            throw new BadRequestException("Some seats not found");
        }
        
        for (Seat seat : seats) {
            if (seat.getStatus() != Seat.SeatStatus.AVAILABLE) {
                throw new BadRequestException("Seat " + seat.getSeatNumber() + " is not available");
            }
        }
        
        // Create booking
        Booking booking = new Booking();
        booking.setBookingId(generateBookingId());
        booking.setUser(user);
        booking.setEvent(event);
        booking.setStatus(Booking.BookingStatus.CONFIRMED);
        booking.setPaymentStatus(Booking.PaymentStatus.PENDING);
        
        // Calculate amount
        BigDecimal totalAmount = event.getPrice().multiply(BigDecimal.valueOf(seats.size()));
        booking.setTotalAmount(totalAmount);
        
        // Apply promotion if provided
        BigDecimal discountAmount = BigDecimal.ZERO;
        if (request.getPromotionCode() != null && !request.getPromotionCode().isEmpty()) {
            Promotion promotion = promotionRepository.findByCode(request.getPromotionCode())
                    .orElse(null);
            
            if (promotion != null && promotion.isValid()) {
                if (promotion.getDiscountType() == Promotion.DiscountType.PERCENTAGE) {
                    discountAmount = totalAmount.multiply(promotion.getDiscountValue().divide(BigDecimal.valueOf(100)));
                } else {
                    discountAmount = promotion.getDiscountValue();
                }
                booking.setPromotion(promotion);
                promotion.setCurrentUsage(promotion.getCurrentUsage() + 1);
                promotionRepository.save(promotion);
            }
        }
        
        booking.setDiscountAmount(discountAmount);
        booking.setFinalAmount(totalAmount.subtract(discountAmount));
        
        booking = bookingRepository.save(booking);
        
        // Reserve seats
        for (Seat seat : seats) {
            seat.setStatus(Seat.SeatStatus.RESERVED);
            seat.setBookedBy(user);
            seat.setReservedUntil(LocalDateTime.now().plusMinutes(15));
        }
        seatRepository.saveAll(seats);
        booking.setSeats(Set.copyOf(seats));
        
        // Update event available seats
        event.setAvailableSeats(event.getAvailableSeats() - seats.size());
        eventRepository.save(event);
        
        return mapBookingToResponse(booking);
    }
    
    @Transactional
    public BookingResponse processPayment(PaymentRequest paymentRequest) {
        Booking booking = bookingRepository.findByBookingId(paymentRequest.getBookingId())
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found"));
        
        if (booking.getPaymentStatus() == Booking.PaymentStatus.SUCCESS) {
            throw new BadRequestException("Payment already processed");
        }
        
        // Process payment (mock implementation)
        boolean paymentSuccess = paymentService.processPayment(paymentRequest, booking.getFinalAmount());
        
        if (paymentSuccess) {
            booking.setPaymentStatus(Booking.PaymentStatus.SUCCESS);
            booking.setStatus(Booking.BookingStatus.CONFIRMED);
            booking.setPaymentTime(LocalDateTime.now());
            booking.setPaymentMethod(paymentRequest.getPaymentMethod());
            booking.setTransactionId(UUID.randomUUID().toString());
            
            // Generate QR code
            String qrContent = "Booking ID: " + booking.getBookingId() + "\n" +
                              "Event: " + booking.getEvent().getName() + "\n" +
                              "Date: " + booking.getEvent().getEventDate() + "\n" +
                              "Venue: " + booking.getEvent().getVenue();
            String qrCode = QRCodeGenerator.generateQRCodeBase64(qrContent);
            booking.setQrCode(qrCode);
            
            // Confirm seats
            List<Seat> seats = seatRepository.findByBookingId(booking.getId());
            for (Seat seat : seats) {
                seat.setStatus(Seat.SeatStatus.BOOKED);
            }
            seatRepository.saveAll(seats);
        } else {
            booking.setPaymentStatus(Booking.PaymentStatus.FAILED);
            booking.setStatus(Booking.BookingStatus.CANCELLED);
            
            // Release seats
            List<Seat> seats = seatRepository.findByBookingId(booking.getId());
            for (Seat seat : seats) {
                seat.setStatus(Seat.SeatStatus.AVAILABLE);
                seat.setBookedBy(null);
            }
            seatRepository.saveAll(seats);
            
            // Update event available seats
            Event event = booking.getEvent();
            event.setAvailableSeats(event.getAvailableSeats() + seats.size());
            eventRepository.save(event);
        }
        
        booking = bookingRepository.save(booking);
        return mapBookingToResponse(booking);
    }
    
    public BookingResponse getBookingById(String bookingId) {
        Booking booking = bookingRepository.findByBookingId(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found"));
        return mapBookingToResponse(booking);
    }
    
    public List<BookingResponse> getUserBookings(Long userId) {
        return bookingRepository.findByUserId(userId).stream()
                .map(this::mapBookingToResponse)
                .collect(Collectors.toList());
    }
    
    public List<BookingResponse> getEventBookings(Long eventId) {
        return bookingRepository.findByEventId(eventId).stream()
                .map(this::mapBookingToResponse)
                .collect(Collectors.toList());
    }
    
    @Transactional
    public BookingResponse cancelBooking(String bookingId) {
        Booking booking = bookingRepository.findByBookingId(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found"));
        
        if (booking.getStatus() == Booking.BookingStatus.CANCELLED) {
            throw new BadRequestException("Booking already cancelled");
        }
        
        booking.setStatus(Booking.BookingStatus.CANCELLED);
        
        // Release seats
        List<Seat> seats = seatRepository.findByBookingId(booking.getId());
        for (Seat seat : seats) {
            seat.setStatus(Seat.SeatStatus.AVAILABLE);
            seat.setBookedBy(null);
        }
        seatRepository.saveAll(seats);
        
        // Update event available seats
        Event event = booking.getEvent();
        event.setAvailableSeats(event.getAvailableSeats() + seats.size());
        eventRepository.save(event);
        
        // Process refund if payment was successful
        if (booking.getPaymentStatus() == Booking.PaymentStatus.SUCCESS) {
            booking.setPaymentStatus(Booking.PaymentStatus.REFUNDED);
            // Actual refund processing would go here
        }
        
        booking = bookingRepository.save(booking);
        return mapBookingToResponse(booking);
    }
    
    private String generateBookingId() {
        return "BK" + System.currentTimeMillis() + UUID.randomUUID().toString().substring(0, 5).toUpperCase();
    }
    
    private BookingResponse mapBookingToResponse(Booking booking) {
        BookingResponse response = new BookingResponse();
        response.setId(booking.getId());
        response.setBookingId(booking.getBookingId());
        response.setUserId(booking.getUser().getId());
        response.setUserName(booking.getUser().getFirstName() + " " + booking.getUser().getLastName());
        response.setUserEmail(booking.getUser().getEmail());
        response.setEventId(booking.getEvent().getId());
        response.setEventName(booking.getEvent().getName());
        response.setEventDate(booking.getEvent().getEventDate());
        response.setVenue(booking.getEvent().getVenue());
        
        Set<Seat> seats = booking.getSeats();
        if (seats != null) {
            response.setSeats(seats.stream().map(this::mapSeatToDto).collect(Collectors.toList()));
        }
        
        response.setTotalAmount(booking.getTotalAmount());
        response.setDiscountAmount(booking.getDiscountAmount());
        response.setFinalAmount(booking.getFinalAmount());
        
        if (booking.getPromotion() != null) {
            response.setPromotionCode(booking.getPromotion().getCode());
        }
        
        response.setStatus(booking.getStatus());
        response.setPaymentStatus(booking.getPaymentStatus());
        response.setPaymentMethod(booking.getPaymentMethod());
        response.setTransactionId(booking.getTransactionId());
        response.setQrCode(booking.getQrCode());
        response.setBookingTime(booking.getBookingTime());
        response.setPaymentTime(booking.getPaymentTime());
        
        return response;
    }
    
    private SeatDto mapSeatToDto(Seat seat) {
        SeatDto dto = new SeatDto();
        dto.setId(seat.getId());
        dto.setSeatNumber(String.valueOf(seat.getSeatNumber()));
        dto.setRow(seat.getRow());
        dto.setSection(seat.getSection() != null ? seat.getSection().getName() : "");
        dto.setStatus(seat.getStatus() != null ? seat.getStatus() : Seat.SeatStatus.AVAILABLE);
        return dto;
    }
}