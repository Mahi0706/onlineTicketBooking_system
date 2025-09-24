package com.ticketbooking.service;

import com.ticketbooking.dto.PaymentRequest;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.Random;

@Service
public class PaymentService {
    
    private final Random random = new Random();
    
    public boolean processPayment(PaymentRequest request, BigDecimal amount) {
        // Mock payment processing
        // In a real application, this would integrate with a payment gateway
        
        // Simulate payment validation
        if (request.getPaymentMethod() == null || request.getPaymentMethod().isEmpty()) {
            return false;
        }
        
        if ("CARD".equalsIgnoreCase(request.getPaymentMethod())) {
            // Validate card details (mock)
            if (request.getCardNumber() == null || request.getCardNumber().length() < 13) {
                return false;
            }
            if (request.getCvv() == null || request.getCvv().length() != 3) {
                return false;
            }
        }
        
        // Simulate payment processing delay
        try {
            Thread.sleep(500);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        
        // Return success 95% of the time (for demo purposes)
        return random.nextDouble() < 0.95;
    }
    
    public boolean processRefund(String transactionId, BigDecimal amount) {
        // Mock refund processing
        // In a real application, this would integrate with a payment gateway
        
        // Simulate refund processing delay
        try {
            Thread.sleep(300);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        
        // Always return success for demo
        return true;
    }
}