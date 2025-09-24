-- Clean and Seed Database for Online Ticket Booking System
-- Password for all users: password123

USE ticket_booking;

-- First, disable foreign key checks
SET FOREIGN_KEY_CHECKS = 0;

-- Drop existing data from all tables that exist
DELETE FROM bookings WHERE 1=1;
DELETE FROM seats WHERE 1=1;
DELETE FROM venue_sections WHERE 1=1;
DELETE FROM events WHERE 1=1;
DELETE FROM promotions WHERE 1=1;
DELETE FROM users WHERE 1=1;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Insert Users (BCrypt hash for 'password123')
INSERT INTO users (email, password, name, phone, role, is_active, preferred_language, preferred_currency, created_at, updated_at) VALUES
('admin@ticketbooking.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye/1lKmQ2Jz3JfAH5fWJzS8.UqNzenUWq', 'Admin User', '+1234567890', 'ADMIN', true, 'en', 'USD', NOW(), NOW()),
('john@organizer.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye/1lKmQ2Jz3JfAH5fWJzS8.UqNzenUWq', 'John Organizer', '+1234567891', 'ORGANIZER', true, 'en', 'USD', NOW(), NOW()),
('sarah@organizer.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye/1lKmQ2Jz3JfAH5fWJzS8.UqNzenUWq', 'Sarah Organizer', '+1234567892', 'ORGANIZER', true, 'en', 'USD', NOW(), NOW()),
('mike@user.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye/1lKmQ2Jz3JfAH5fWJzS8.UqNzenUWq', 'Mike Wilson', '+1234567893', 'USER', true, 'en', 'USD', NOW(), NOW()),
('emma@user.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye/1lKmQ2Jz3JfAH5fWJzS8.UqNzenUWq', 'Emma Davis', '+1234567894', 'USER', true, 'en', 'USD', NOW(), NOW()),
('test@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye/1lKmQ2Jz3JfAH5fWJzS8.UqNzenUWq', 'Test User', '+1234567895', 'USER', true, 'en', 'USD', NOW(), NOW());

-- Get user IDs
SET @admin_id = (SELECT id FROM users WHERE email = 'admin@ticketbooking.com');
SET @john_id = (SELECT id FROM users WHERE email = 'john@organizer.com');
SET @sarah_id = (SELECT id FROM users WHERE email = 'sarah@organizer.com');
SET @mike_id = (SELECT id FROM users WHERE email = 'mike@user.com');
SET @emma_id = (SELECT id FROM users WHERE email = 'emma@user.com');

-- Insert Events
INSERT INTO events (name, description, type, event_date, venue, address, total_seats, available_seats, price, organizer_id, created_at, updated_at, active) VALUES
-- Concerts
('Rock Concert 2025', 'Amazing rock concert featuring top bands', 'CONCERT', '2025-03-15 20:00:00', 'Madison Square Garden', 'New York, NY', 500, 500, 75.00, @john_id, NOW(), NOW(), true),
('Taylor Swift - Eras Tour', 'Experience the magic of Taylor Swift live', 'CONCERT', '2025-04-20 19:30:00', 'MetLife Stadium', 'East Rutherford, NJ', 1000, 995, 250.00, @john_id, NOW(), NOW(), true),
('Jazz Night Special', 'An evening of smooth jazz', 'CONCERT', '2025-03-25 21:00:00', 'Blue Note', 'New York, NY', 200, 195, 65.00, @sarah_id, NOW(), NOW(), true),

-- Movies
('The Avengers: Endgame Special Screening', 'Special IMAX screening with cast Q&A', 'MOVIE', '2025-02-20 19:30:00', 'AMC Theater', 'Los Angeles, CA', 300, 295, 25.00, @john_id, NOW(), NOW(), true),
('Dune: Part Three', 'The epic conclusion to the Dune saga', 'MOVIE', '2025-05-01 18:00:00', 'TCL Chinese Theatre', 'Hollywood, CA', 400, 395, 30.00, @sarah_id, NOW(), NOW(), true),
('Star Wars: New Hope', 'Classic movie night', 'MOVIE', '2025-03-10 20:00:00', 'Regal Cinema', 'Chicago, IL', 250, 245, 15.00, @john_id, NOW(), NOW(), true),

-- Sports
('NBA Finals Game 7', 'Championship deciding game', 'SPORTS', '2025-06-20 21:00:00', 'Staples Center', 'Los Angeles, CA', 1500, 1490, 350.00, @john_id, NOW(), NOW(), true),
('FIFA World Cup Qualifier', 'USA vs Mexico', 'SPORTS', '2025-03-28 19:00:00', 'Rose Bowl', 'Pasadena, CA', 2000, 1985, 120.00, @sarah_id, NOW(), NOW(), true),
('Boxing Championship', 'Heavyweight title fight', 'SPORTS', '2025-04-15 22:00:00', 'MGM Grand', 'Las Vegas, NV', 800, 790, 200.00, @john_id, NOW(), NOW(), true),

-- Theater
('Broadway: Hamilton', 'Award-winning musical', 'THEATER', '2025-04-10 19:00:00', 'Broadway Theater', 'New York, NY', 500, 485, 150.00, @sarah_id, NOW(), NOW(), true),
('Shakespeare: Romeo and Juliet', 'Classic romantic tragedy', 'THEATER', '2025-05-05 19:30:00', 'Globe Theatre', 'Boston, MA', 300, 295, 80.00, @john_id, NOW(), NOW(), true),
('The Lion King Musical', 'Disney Broadway spectacular', 'THEATER', '2025-06-01 20:00:00', 'Lyceum Theatre', 'New York, NY', 600, 590, 175.00, @sarah_id, NOW(), NOW(), true),

-- Conferences
('Tech Conference 2025', 'Annual technology summit', 'CONFERENCE', '2025-09-15 09:00:00', 'Convention Center', 'San Francisco, CA', 1000, 980, 299.00, @john_id, NOW(), NOW(), true),
('Google I/O', 'Developer conference by Google', 'CONFERENCE', '2025-05-07 10:00:00', 'Shoreline Amphitheatre', 'Mountain View, CA', 800, 785, 350.00, @sarah_id, NOW(), NOW(), true),

-- Comedy/Other
('Stand-up Comedy Night', 'Featuring top comedians', 'OTHER', '2025-03-30 20:00:00', 'Comedy Club', 'Chicago, IL', 150, 145, 45.00, @john_id, NOW(), NOW(), true),
('Magic Show Spectacular', 'Mind-blowing illusions', 'OTHER', '2025-04-05 19:00:00', 'Magic Theater', 'Las Vegas, NV', 300, 295, 60.00, @sarah_id, NOW(), NOW(), true);

-- Insert Promotions
INSERT INTO promotions (code, description, discount_type, discount_value, valid_from, valid_until, max_usage, current_usage, active, created_at) VALUES
('WELCOME10', 'Welcome discount - 10% off', 'PERCENTAGE', 10.00, '2025-01-01', '2025-12-31', 1000, 0, true, NOW()),
('STUDENT20', 'Student discount - 20% off', 'PERCENTAGE', 20.00, '2025-01-01', '2025-12-31', 500, 0, true, NOW()),
('EARLY15', 'Early bird - 15% off', 'PERCENTAGE', 15.00, '2025-01-01', '2025-03-31', 200, 0, true, NOW()),
('SAVE50', 'Save $50 on orders over $200', 'FIXED_AMOUNT', 50.00, '2025-01-01', '2025-12-31', 100, 0, true, NOW()),
('WEEKEND25', 'Weekend special - 25% off', 'PERCENTAGE', 25.00, '2025-01-01', '2025-12-31', 300, 0, true, NOW());

-- Get event ID for Taylor Swift concert
SET @event_id = (SELECT id FROM events WHERE name LIKE 'Taylor Swift%' LIMIT 1);

-- Create sample bookings if event exists
INSERT INTO bookings (booking_reference, booking_id, user_id, event_id, booking_date, booking_time, total_amount, discount_amount, final_amount, currency, payment_status, booking_status, payment_method, status)
SELECT
    CONCAT('BK', UNIX_TIMESTAMP()),
    CONCAT('BKID', UNIX_TIMESTAMP()),
    @mike_id,
    @event_id,
    NOW(),
    NOW(),
    250.00,
    25.00,
    225.00,
    'USD',
    'SUCCESS',
    'CONFIRMED',
    'CREDIT_CARD',
    'CONFIRMED'
WHERE @event_id IS NOT NULL;

-- Display summary
SELECT 'Database seeded successfully!' as Message;
SELECT
    (SELECT COUNT(*) FROM users) as Users,
    (SELECT COUNT(*) FROM events) as Events,
    (SELECT COUNT(*) FROM promotions) as Promotions,
    (SELECT COUNT(*) FROM bookings) as Bookings;