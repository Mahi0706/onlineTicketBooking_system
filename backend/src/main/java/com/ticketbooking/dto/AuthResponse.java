package com.ticketbooking.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.Map;

@Data
@AllArgsConstructor
public class AuthResponse {
    private String token;
    private String type = "Bearer";
    private Map<String, Object> user;

    public AuthResponse(String token, Map<String, Object> user) {
        this.token = token;
        this.user = user;
        this.type = "Bearer";
    }
}