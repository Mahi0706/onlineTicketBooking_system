package com.ticketbooking.dto;

import com.ticketbooking.entity.Event;
import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class EventDto {
    private Long id;
    
    @NotBlank(message = "Event name is required")
    private String name;
    
    private String description;
    
    private Event.EventType type;
    
    @NotNull(message = "Event date is required")
    @Future(message = "Event date must be in the future")
    private LocalDateTime eventDate;
    
    @NotBlank(message = "Venue is required")
    private String venue;
    
    private String address;
    
    @NotNull(message = "Total seats is required")
    @Min(value = 1, message = "Total seats must be at least 1")
    private Integer totalSeats;
    
    private Integer availableSeats;
    
    @NotNull(message = "Price is required")
    @Min(value = 0, message = "Price cannot be negative")
    private BigDecimal price;
    
    private String imageUrl;
    
    private Long organizerId;
    private String organizerName;
    
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    private Boolean active;
}