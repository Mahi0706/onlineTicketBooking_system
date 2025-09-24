package com.ticketbooking.service;

import com.ticketbooking.dto.EventDto;
import com.ticketbooking.entity.Event;
import com.ticketbooking.entity.Seat;
import com.ticketbooking.entity.User;
import com.ticketbooking.exception.ResourceNotFoundException;
import com.ticketbooking.repository.EventRepository;
import com.ticketbooking.repository.SeatRepository;
import com.ticketbooking.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class EventService {
    @Autowired
    private EventRepository eventRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private SeatRepository seatRepository;
    
    @Transactional
    public EventDto createEvent(EventDto eventDto, Long organizerId) {
        User organizer = userRepository.findById(organizerId)
                .orElseThrow(() -> new ResourceNotFoundException("Organizer not found"));
        
        Event event = new Event();
        mapDtoToEntity(eventDto, event);
        event.setOrganizer(organizer);
        event.setAvailableSeats(eventDto.getTotalSeats());
        
        event = eventRepository.save(event);
        
        // Generate seats
        List<Seat> seats = generateSeats(event);
        seatRepository.saveAll(seats);
        
        return mapEntityToDto(event);
    }
    
    public EventDto updateEvent(Long id, EventDto eventDto) {
        Event event = eventRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Event not found"));
        
        mapDtoToEntity(eventDto, event);
        event = eventRepository.save(event);
        
        return mapEntityToDto(event);
    }
    
    public EventDto getEventById(Long id) {
        Event event = eventRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Event not found"));
        return mapEntityToDto(event);
    }
    
    public List<EventDto> getAllEvents() {
        return eventRepository.findByActiveTrue().stream()
                .map(this::mapEntityToDto)
                .collect(Collectors.toList());
    }
    
    public List<EventDto> getUpcomingEvents() {
        return eventRepository.findUpcomingEvents(LocalDateTime.now()).stream()
                .map(this::mapEntityToDto)
                .collect(Collectors.toList());
    }
    
    public List<EventDto> searchEvents(String query) {
        return eventRepository.searchEvents(query).stream()
                .map(this::mapEntityToDto)
                .collect(Collectors.toList());
    }
    
    public List<EventDto> getEventsByType(Event.EventType type) {
        return eventRepository.findByType(type).stream()
                .map(this::mapEntityToDto)
                .collect(Collectors.toList());
    }
    
    public List<EventDto> getOrganizerEvents(Long organizerId) {
        return eventRepository.findByOrganizerId(organizerId).stream()
                .map(this::mapEntityToDto)
                .collect(Collectors.toList());
    }
    
    @Transactional
    public void deleteEvent(Long id) {
        Event event = eventRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Event not found"));
        event.setActive(false);
        eventRepository.save(event);
    }
    
    private List<Seat> generateSeats(Event event) {
        List<Seat> seats = new ArrayList<>();
        int rows = (int) Math.ceil(event.getTotalSeats() / 10.0);
        int seatCount = 0;
        
        for (int row = 1; row <= rows && seatCount < event.getTotalSeats(); row++) {
            for (int col = 1; col <= 10 && seatCount < event.getTotalSeats(); col++) {
                Seat seat = new Seat();
                seat.setEvent(event);
                seat.setRowLabel(String.valueOf((char) ('A' + row - 1)));
                seat.setSeatNumber(String.valueOf(col));
                seat.setPrice(event.getPrice());
                seat.setStatus(Seat.SeatStatus.AVAILABLE);
                seats.add(seat);
                seatCount++;
            }
        }
        
        return seats;
    }
    
    private void mapDtoToEntity(EventDto dto, Event entity) {
        entity.setName(dto.getName());
        entity.setDescription(dto.getDescription());
        entity.setType(dto.getType());
        entity.setEventDate(dto.getEventDate());
        entity.setVenue(dto.getVenue());
        entity.setAddress(dto.getAddress());
        entity.setTotalSeats(dto.getTotalSeats());
        entity.setPrice(dto.getPrice());
        entity.setImageUrl(dto.getImageUrl());
        if (dto.getActive() != null) {
            entity.setActive(dto.getActive());
        }
    }
    
    private EventDto mapEntityToDto(Event entity) {
        EventDto dto = new EventDto();
        dto.setId(entity.getId());
        dto.setName(entity.getName());
        dto.setDescription(entity.getDescription());
        dto.setType(entity.getType());
        dto.setEventDate(entity.getEventDate());
        dto.setVenue(entity.getVenue());
        dto.setAddress(entity.getAddress());
        dto.setTotalSeats(entity.getTotalSeats());
        dto.setAvailableSeats(entity.getAvailableSeats());
        dto.setPrice(entity.getPrice());
        dto.setImageUrl(entity.getImageUrl());
        if (entity.getOrganizer() != null) {
            dto.setOrganizerId(entity.getOrganizer().getId());
            dto.setOrganizerName(entity.getOrganizer().getFirstName() + " " + entity.getOrganizer().getLastName());
        }
        dto.setCreatedAt(entity.getCreatedAt());
        dto.setUpdatedAt(entity.getUpdatedAt());
        dto.setActive(entity.getActive());
        return dto;
    }
}