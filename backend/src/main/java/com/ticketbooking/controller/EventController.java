package com.ticketbooking.controller;

import com.ticketbooking.dto.EventDto;
import com.ticketbooking.dto.SeatDto;
import com.ticketbooking.entity.Event;
import com.ticketbooking.entity.Seat;
import com.ticketbooking.entity.User;
import com.ticketbooking.repository.SeatRepository;
import com.ticketbooking.service.EventService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/events")
@CrossOrigin
public class EventController {
    
    @Autowired
    private EventService eventService;
    
    @Autowired
    private SeatRepository seatRepository;
    
    @PostMapping
    @PreAuthorize("hasRole('ORGANIZER')")
    public ResponseEntity<EventDto> createEvent(@Valid @RequestBody EventDto eventDto, Authentication authentication) {
        User user = (User) authentication.getPrincipal();
        EventDto createdEvent = eventService.createEvent(eventDto, user.getId());
        return new ResponseEntity<>(createdEvent, HttpStatus.CREATED);
    }
    
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ORGANIZER')")
    public ResponseEntity<EventDto> updateEvent(@PathVariable Long id, @Valid @RequestBody EventDto eventDto) {
        EventDto updatedEvent = eventService.updateEvent(id, eventDto);
        return ResponseEntity.ok(updatedEvent);
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<EventDto> getEventById(@PathVariable Long id) {
        EventDto event = eventService.getEventById(id);
        return ResponseEntity.ok(event);
    }
    
    @GetMapping("/public/all")
    public ResponseEntity<List<EventDto>> getAllEvents() {
        List<EventDto> events = eventService.getAllEvents();
        return ResponseEntity.ok(events);
    }
    
    @GetMapping("/public/upcoming")
    public ResponseEntity<List<EventDto>> getUpcomingEvents() {
        List<EventDto> events = eventService.getUpcomingEvents();
        return ResponseEntity.ok(events);
    }
    
    @GetMapping("/search")
    public ResponseEntity<List<EventDto>> searchEvents(@RequestParam String query) {
        List<EventDto> events = eventService.searchEvents(query);
        return ResponseEntity.ok(events);
    }
    
    @GetMapping("/public/type/{type}")
    public ResponseEntity<List<EventDto>> getEventsByType(@PathVariable String type) {
        Event.EventType eventType = Event.EventType.valueOf(type.toUpperCase());
        List<EventDto> events = eventService.getEventsByType(eventType);
        return ResponseEntity.ok(events);
    }
    
    @GetMapping("/organizer")
    @PreAuthorize("hasRole('ORGANIZER')")
    public ResponseEntity<List<EventDto>> getOrganizerEvents(Authentication authentication) {
        User user = (User) authentication.getPrincipal();
        List<EventDto> events = eventService.getOrganizerEvents(user.getId());
        return ResponseEntity.ok(events);
    }
    
    @GetMapping("/{eventId}/seats")
    public ResponseEntity<List<SeatDto>> getEventSeats(@PathVariable Long eventId) {
        List<Seat> seats = seatRepository.findByEventId(eventId);
        List<SeatDto> seatDtos = seats.stream().map(this::mapSeatToDto).collect(Collectors.toList());
        return ResponseEntity.ok(seatDtos);
    }
    
    @GetMapping("/{eventId}/available-seats")
    public ResponseEntity<List<SeatDto>> getAvailableSeats(@PathVariable Long eventId) {
        List<Seat> seats = seatRepository.findAvailableSeatsByEventId(eventId);
        List<SeatDto> seatDtos = seats.stream().map(this::mapSeatToDto).collect(Collectors.toList());
        return ResponseEntity.ok(seatDtos);
    }
    
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ORGANIZER') or hasRole('ADMIN')")
    public ResponseEntity<Void> deleteEvent(@PathVariable Long id) {
        eventService.deleteEvent(id);
        return ResponseEntity.noContent().build();
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