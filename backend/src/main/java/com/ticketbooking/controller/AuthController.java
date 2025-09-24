package com.ticketbooking.controller;

import com.ticketbooking.dto.*;
import com.ticketbooking.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin
public class AuthController {

    @Autowired
    private AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> registerUser(@Valid @RequestBody SignupRequest signupRequest) {
        AuthResponse response = authService.register(signupRequest);
        return new ResponseEntity<>(response, HttpStatus.CREATED);
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) {
        AuthResponse response = authService.authenticate(loginRequest);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/me")
    public ResponseEntity<?> getCurrentUser(@RequestHeader("Authorization") String token) {
        return ResponseEntity.ok(authService.getCurrentUser(token));
    }

    @PostMapping("/signup")
    public ResponseEntity<AuthResponse> signupUser(@Valid @RequestBody RegistrationRequest registrationRequest) {
        SignupRequest signupRequest = new SignupRequest();
        signupRequest.setEmail(registrationRequest.getEmail());
        signupRequest.setPassword(registrationRequest.getPassword());
        signupRequest.setFirstName(registrationRequest.getFirstName() != null ?
            registrationRequest.getFirstName() :
            registrationRequest.getName().split(" ")[0]);
        signupRequest.setLastName(registrationRequest.getLastName() != null ?
            registrationRequest.getLastName() :
            registrationRequest.getName().substring(registrationRequest.getName().indexOf(" ") + 1));
        signupRequest.setPhone(registrationRequest.getPhone());

        AuthResponse response = authService.register(signupRequest);
        return new ResponseEntity<>(response, HttpStatus.CREATED);
    }

    @PostMapping("/verify")
    public ResponseEntity<Map<String, Object>> verifyAccount(@Valid @RequestBody VerificationRequest verificationRequest) {
        Map<String, Object> response = new HashMap<>();

        // Mock verification for demo - in production, implement actual verification
        if ("123456".equals(verificationRequest.getCode())) {
            response.put("success", true);
            response.put("message", "Account verified successfully");
            return ResponseEntity.ok(response);
        } else {
            response.put("success", false);
            response.put("message", "Invalid verification code");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
        }
    }

    @PostMapping("/resend-verification")
    public ResponseEntity<Map<String, Object>> resendVerification(@RequestBody Map<String, String> request) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Verification code sent successfully");
        return ResponseEntity.ok(response);
    }

    @PostMapping("/forgot-password")
    public ResponseEntity<Map<String, Object>> forgotPassword(@RequestBody Map<String, String> request) {
        Map<String, Object> response = new HashMap<>();
        String email = request.get("email");

        if (email != null && !email.isEmpty()) {
            response.put("success", true);
            response.put("message", "Password reset code sent to your email");
            return ResponseEntity.ok(response);
        } else {
            response.put("success", false);
            response.put("message", "Email is required");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
        }
    }

    @PostMapping("/verify-reset-code")
    public ResponseEntity<Map<String, Object>> verifyResetCode(@RequestBody Map<String, String> request) {
        Map<String, Object> response = new HashMap<>();
        String code = request.get("code");

        // Mock verification for demo
        if ("123456".equals(code)) {
            response.put("success", true);
            response.put("message", "Code verified successfully");
            return ResponseEntity.ok(response);
        } else {
            response.put("success", false);
            response.put("message", "Invalid reset code");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
        }
    }

    @PostMapping("/reset-password")
    public ResponseEntity<Map<String, Object>> resetPassword(@Valid @RequestBody PasswordResetRequest request) {
        Map<String, Object> response = new HashMap<>();

        // Mock password reset for demo
        if (request.getEmail() != null && request.getNewPassword() != null) {
            response.put("success", true);
            response.put("message", "Password reset successfully");
            return ResponseEntity.ok(response);
        } else {
            response.put("success", false);
            response.put("message", "Failed to reset password");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
        }
    }
}