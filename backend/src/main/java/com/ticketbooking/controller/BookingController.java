package com.ticketbooking.controller;

import com.ticketbooking.dto.BookingRequest;
import com.ticketbooking.dto.BookingResponse;
import com.ticketbooking.dto.PaymentRequest;
import com.ticketbooking.entity.User;
import com.ticketbooking.service.BookingService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/bookings")
@CrossOrigin
public class BookingController {
    
    @Autowired
    private BookingService bookingService;
    
    @PostMapping
    public ResponseEntity<BookingResponse> createBooking(
            @Valid @RequestBody BookingRequest request,
            Authentication authentication) {
        User user = (User) authentication.getPrincipal();
        BookingResponse response = bookingService.createBooking(request, user.getId());
        return new ResponseEntity<>(response, HttpStatus.CREATED);
    }
    
    @PostMapping("/payment")
    public ResponseEntity<BookingResponse> processPayment(@Valid @RequestBody PaymentRequest request) {
        BookingResponse response = bookingService.processPayment(request);
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/{bookingId}")
    public ResponseEntity<BookingResponse> getBooking(@PathVariable String bookingId) {
        BookingResponse response = bookingService.getBookingById(bookingId);
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/user")
    public ResponseEntity<List<BookingResponse>> getUserBookings(Authentication authentication) {
        User user = (User) authentication.getPrincipal();
        List<BookingResponse> bookings = bookingService.getUserBookings(user.getId());
        return ResponseEntity.ok(bookings);
    }
    
    @GetMapping("/event/{eventId}")
    public ResponseEntity<List<BookingResponse>> getEventBookings(@PathVariable Long eventId) {
        List<BookingResponse> bookings = bookingService.getEventBookings(eventId);
        return ResponseEntity.ok(bookings);
    }
    
    @PutMapping("/{bookingId}/cancel")
    public ResponseEntity<BookingResponse> cancelBooking(@PathVariable String bookingId) {
        BookingResponse response = bookingService.cancelBooking(bookingId);
        return ResponseEntity.ok(response);
    }
}