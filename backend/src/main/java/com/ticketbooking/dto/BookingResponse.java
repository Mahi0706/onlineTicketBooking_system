package com.ticketbooking.dto;

import com.ticketbooking.entity.Booking;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class BookingResponse {
    private Long id;
    private String bookingId;
    private Long userId;
    private String userName;
    private String userEmail;
    private Long eventId;
    private String eventName;
    private LocalDateTime eventDate;
    private String venue;
    private List<SeatDto> seats;
    private BigDecimal totalAmount;
    private BigDecimal discountAmount;
    private BigDecimal finalAmount;
    private String promotionCode;
    private Booking.BookingStatus status;
    private Booking.PaymentStatus paymentStatus;
    private String paymentMethod;
    private String transactionId;
    private String qrCode;
    private LocalDateTime bookingTime;
    private LocalDateTime paymentTime;
}