package com.ticketbooking.dto;

import com.ticketbooking.entity.Seat;
import lombok.Data;

@Data
public class SeatDto {
    private Long id;
    private String seatNumber;
    private String row;
    private String section;
    private Seat.SeatStatus status;
}