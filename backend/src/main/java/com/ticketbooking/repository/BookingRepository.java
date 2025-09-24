package com.ticketbooking.repository;

import com.ticketbooking.entity.Booking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Long> {
    Optional<Booking> findByBookingId(String bookingId);
    
    List<Booking> findByUserId(Long userId);
    
    List<Booking> findByEventId(Long eventId);
    
    @Query("SELECT b FROM Booking b WHERE b.event.organizer.id = :organizerId")
    List<Booking> findByOrganizerId(@Param("organizerId") Long organizerId);
    
    @Query("SELECT COUNT(b) FROM Booking b WHERE b.event.id = :eventId AND b.status = 'CONFIRMED'")
    Long countConfirmedBookingsByEventId(@Param("eventId") Long eventId);
}