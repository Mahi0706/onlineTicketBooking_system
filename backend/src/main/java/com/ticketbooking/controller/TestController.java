package com.ticketbooking.controller;

import com.ticketbooking.dto.AuthResponse;
import com.ticketbooking.dto.LoginRequest;
import com.ticketbooking.entity.User;
import com.ticketbooking.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/test")
public class TestController {

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/public")
    public Map<String, String> publicEndpoint() {
        Map<String, String> response = new HashMap<>();
        response.put("message", "Backend is running successfully!");
        response.put("status", "OK");
        response.put("timestamp", String.valueOf(System.currentTimeMillis()));
        return response;
    }

    @GetMapping("/hash")
    public String generateHash(@RequestParam(defaultValue = "secret") String password) {
        return passwordEncoder.encode(password);
    }

    @GetMapping("/verify")
    public boolean verifyPassword(@RequestParam String password, @RequestParam String hash) {
        return passwordEncoder.matches(password, hash);
    }

    @PostMapping("/reset-password")
    public String resetPassword(@RequestParam String email, @RequestParam(defaultValue = "secret") String newPassword) {
        User user = userRepository.findByEmail(email).orElse(null);
        if (user != null) {
            user.setPassword(passwordEncoder.encode(newPassword));
            userRepository.save(user);
            return "Password reset successfully for " + email + " to: " + newPassword;
        }
        return "User not found: " + email;
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> testLogin(@RequestBody LoginRequest loginRequest) {
        // Simple mock authentication for testing
        User user = userRepository.findByEmail(loginRequest.getEmail()).orElse(null);
        if (user != null && user.getPassword().equals(loginRequest.getPassword())) {
            Map<String, Object> userMap = createUserMap(user);
            AuthResponse response = new AuthResponse("mock-jwt-token-" + System.currentTimeMillis(), userMap);
            return ResponseEntity.ok(response);
        }
        return ResponseEntity.status(401).build();
    }

    @GetMapping("/me")
    public ResponseEntity<Map<String, Object>> testGetUser(@RequestParam(defaultValue = "user@ticketbooking.com") String email) {
        User user = userRepository.findByEmail(email).orElse(null);
        if (user != null) {
            return ResponseEntity.ok(createUserMap(user));
        }
        return ResponseEntity.status(404).build();
    }

    private Map<String, Object> createUserMap(User user) {
        Map<String, Object> userMap = new HashMap<>();
        userMap.put("id", user.getId().toString());
        userMap.put("email", user.getEmail());
        userMap.put("name", user.getName());
        userMap.put("role", user.getRole().name());
        userMap.put("phone", user.getPhone());
        userMap.put("preferredLanguage", user.getPreferredLanguage());
        userMap.put("preferredCurrency", user.getPreferredCurrency());
        return userMap;
    }
}