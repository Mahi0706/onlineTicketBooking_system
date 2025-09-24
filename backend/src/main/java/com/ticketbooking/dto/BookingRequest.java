package com.ticketbooking.dto;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

@Data
public class BookingRequest {
    @NotNull(message = "Event ID is required")
    private Long eventId;
    
    @NotEmpty(message = "At least one seat must be selected")
    private List<Long> seatIds;
    
    private String promotionCode;
    
    private String paymentMethod;
}