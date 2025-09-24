package com.ticketbooking.repository;

import com.ticketbooking.entity.Seat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SeatRepository extends JpaRepository<Seat, Long> {
    List<Seat> findByEventId(Long eventId);
    
    @Query("SELECT s FROM Seat s WHERE s.event.id = :eventId AND s.status = 'AVAILABLE'")
    List<Seat> findAvailableSeatsByEventId(@Param("eventId") Long eventId);
    
    @Query("SELECT s FROM Booking b JOIN b.seats s WHERE b.id = :bookingId")
    List<Seat> findByBookingId(@Param("bookingId") Long bookingId);
}