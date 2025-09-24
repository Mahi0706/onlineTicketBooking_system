package com.ticketbooking.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "pricing_rules")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PricingRule {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "event_id", nullable = false)
    private Event event;

    @Enumerated(EnumType.STRING)
    @Column(name = "rule_type", nullable = false)
    private RuleType ruleType;

    @Column(name = "threshold_value")
    private BigDecimal thresholdValue;

    private BigDecimal multiplier;

    @Column(name = "discount_percentage")
    private BigDecimal discountPercentage;

    @Column(name = "min_group_size")
    private Integer minGroupSize;

    private Boolean active = true;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    public enum RuleType {
        OCCUPANCY,      // Price changes based on occupancy percentage
        TIME_BASED,     // Price changes based on time until event
        DAY_OF_WEEK,    // Different prices for different days
        GROUP_DISCOUNT  // Discount for group bookings
    }
}