-- Seed Data for Online Ticket Booking System
-- Clear existing data
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE bookings;
TRUNCATE TABLE seats;
TRUNCATE TABLE venue_sections;
TRUNCATE TABLE events;
TRUNCATE TABLE categories;
TRUNCATE TABLE users;
TRUNCATE TABLE promotions;
SET FOREIGN_KEY_CHECKS = 1;

-- Insert Users (passwords are 'password123' encoded with BCrypt)
INSERT INTO users (id, email, password, name, first_name, last_name, phone, role, is_active, preferred_language, preferred_currency, created_at, updated_at) VALUES
(1, 'admin@ticketbooking.com', '$2a$10$YourHashedPasswordHere', 'Admin User', 'Admin', 'User', '+1234567890', 'ADMIN', true, 'en', 'USD', NOW(), NOW()),
(2, 'john@organizer.com', '$2a$10$YourHashedPasswordHere', 'John Smith', 'John', 'Smith', '+1234567891', 'ORGANIZER', true, 'en', 'USD', NOW(), NOW()),
(3, 'sarah@organizer.com', '$2a$10$YourHashedPasswordHere', 'Sarah Johnson', 'Sarah', 'Johnson', '+1234567892', 'ORGANIZER', true, 'en', 'USD', NOW(), NOW()),
(4, 'mike@user.com', '$2a$10$YourHashedPasswordHere', 'Mike Wilson', 'Mike', 'Wilson', '+1234567893', 'USER', true, 'en', 'USD', NOW(), NOW()),
(5, 'emma@user.com', '$2a$10$YourHashedPasswordHere', 'Emma Davis', 'Emma', 'Davis', '+1234567894', 'USER', true, 'en', 'USD', NOW(), NOW()),
(6, 'david@user.com', '$2a$10$YourHashedPasswordHere', 'David Brown', 'David', 'Brown', '+1234567895', 'USER', true, 'en', 'USD', NOW(), NOW());

-- Insert Categories
INSERT INTO categories (id, name, description) VALUES
(1, 'CONCERT', 'Musical concerts and live performances'),
(2, 'MOVIE', 'Movie screenings and premieres'),
(3, 'SPORTS', 'Sports events and matches'),
(4, 'THEATER', 'Theater plays and musicals'),
(5, 'CONFERENCE', 'Business and tech conferences'),
(6, 'COMEDY', 'Stand-up comedy shows');

-- Insert Events
INSERT INTO events (id, name, description, event_type, event_date, venue, address, total_seats, available_seats, price, image_url, organizer_id, created_at, updated_at, active, category_id, currency, genre, status) VALUES
-- Concerts
(1, 'Taylor Swift - Eras Tour', 'Experience the spectacular Eras Tour featuring hits from Taylor Swift entire career', 'CONCERT', '2025-03-15 19:30:00', 'MetLife Stadium', 'East Rutherford, NJ', 500, 450, 250.00, 'https://example.com/taylor-swift.jpg', 2, NOW(), NOW(), true, 1, 'USD', 'Pop', 'UPCOMING'),
(2, 'Ed Sheeran Live 2025', 'An intimate evening with Ed Sheeran performing his greatest hits', 'CONCERT', '2025-04-20 20:00:00', 'Madison Square Garden', 'New York, NY', 400, 380, 180.00, 'https://example.com/ed-sheeran.jpg', 2, NOW(), NOW(), true, 1, 'USD', 'Pop', 'UPCOMING'),
(3, 'Metallica World Tour', 'Heavy metal legends Metallica bring their explosive show', 'CONCERT', '2025-05-10 19:00:00', 'Staples Center', 'Los Angeles, CA', 600, 550, 150.00, 'https://example.com/metallica.jpg', 3, NOW(), NOW(), true, 1, 'USD', 'Metal', 'UPCOMING'),

-- Movies
(4, 'Dune: Part Three - Premiere', 'Exclusive premiere screening of the epic conclusion to the Dune trilogy', 'MOVIE', '2025-03-01 19:00:00', 'TCL Chinese Theatre', 'Hollywood, CA', 300, 280, 50.00, 'https://example.com/dune3.jpg', 2, NOW(), NOW(), true, 2, 'USD', 'Sci-Fi', 'UPCOMING'),
(5, 'Marvel Studios: Avengers 5', 'First screening of the next Avengers movie', 'MOVIE', '2025-05-05 18:30:00', 'AMC Times Square', 'New York, NY', 250, 200, 35.00, 'https://example.com/avengers5.jpg', 3, NOW(), NOW(), true, 2, 'USD', 'Action', 'UPCOMING'),
(6, 'Christopher Nolan New Film', 'Mystery premiere of Christopher Nolan latest masterpiece', 'MOVIE', '2025-07-20 20:00:00', 'IMAX Theater', 'Los Angeles, CA', 200, 190, 45.00, 'https://example.com/nolan.jpg', 2, NOW(), NOW(), true, 2, 'USD', 'Thriller', 'UPCOMING'),

-- Sports
(7, 'NBA Finals - Game 7', 'The championship deciding game of the NBA Finals', 'SPORTS', '2025-06-15 21:00:00', 'Chase Center', 'San Francisco, CA', 800, 750, 350.00, 'https://example.com/nba-finals.jpg', 3, NOW(), NOW(), true, 3, 'USD', 'Basketball', 'UPCOMING'),
(8, 'FIFA World Cup Qualifier', 'USA vs Mexico - World Cup qualifying match', 'SPORTS', '2025-03-28 19:00:00', 'Rose Bowl', 'Pasadena, CA', 1000, 900, 120.00, 'https://example.com/fifa.jpg', 2, NOW(), NOW(), true, 3, 'USD', 'Soccer', 'UPCOMING'),
(9, 'Super Bowl LX', 'The biggest game in American football', 'SPORTS', '2026-02-07 18:30:00', 'SoFi Stadium', 'Los Angeles, CA', 700, 650, 500.00, 'https://example.com/superbowl.jpg', 3, NOW(), NOW(), true, 3, 'USD', 'Football', 'UPCOMING'),

-- Theater
(10, 'Hamilton - Broadway', 'The award-winning musical about Alexander Hamilton', 'THEATER', '2025-04-10 19:30:00', 'Richard Rodgers Theatre', 'New York, NY', 350, 300, 200.00, 'https://example.com/hamilton.jpg', 2, NOW(), NOW(), true, 4, 'USD', 'Musical', 'UPCOMING'),
(11, 'The Lion King Musical', 'Disney spectacular musical adaptation', 'THEATER', '2025-05-15 20:00:00', 'Lyceum Theatre', 'London, UK', 400, 350, 180.00, 'https://example.com/lionking.jpg', 3, NOW(), NOW(), true, 4, 'USD', 'Musical', 'UPCOMING'),
(12, 'Shakespeare: Hamlet', 'Classic performance of Shakespeare timeless tragedy', 'THEATER', '2025-06-20 19:00:00', 'Globe Theatre', 'London, UK', 300, 280, 90.00, 'https://example.com/hamlet.jpg', 2, NOW(), NOW(), true, 4, 'USD', 'Drama', 'UPCOMING'),

-- Conferences
(13, 'TechCrunch Disrupt 2025', 'Premier technology conference featuring startups and innovations', 'CONFERENCE', '2025-09-20 09:00:00', 'Moscone Center', 'San Francisco, CA', 500, 450, 450.00, 'https://example.com/techcrunch.jpg', 3, NOW(), NOW(), true, 5, 'USD', 'Technology', 'UPCOMING'),
(14, 'Google I/O 2025', 'Google annual developer conference', 'CONFERENCE', '2025-05-07 10:00:00', 'Shoreline Amphitheatre', 'Mountain View, CA', 600, 550, 350.00, 'https://example.com/googleio.jpg', 2, NOW(), NOW(), true, 5, 'USD', 'Technology', 'UPCOMING'),

-- Comedy
(15, 'Dave Chappelle Live', 'Stand-up comedy special with Dave Chappelle', 'OTHER', '2025-04-01 20:00:00', 'Comedy Store', 'Los Angeles, CA', 200, 150, 80.00, 'https://example.com/chappelle.jpg', 3, NOW(), NOW(), true, 6, 'USD', 'Comedy', 'UPCOMING');

-- Insert Promotions
INSERT INTO promotions (id, code, description, discount_type, discount_value, event_id, valid_from, valid_until, max_usage, current_usage, active, created_at) VALUES
(1, 'EARLY2025', 'Early bird discount for 2025 events', 'PERCENTAGE', 20.00, NULL, '2025-01-01 00:00:00', '2025-02-28 23:59:59', 100, 0, true, NOW()),
(2, 'STUDENT20', 'Student discount - 20% off', 'PERCENTAGE', 20.00, NULL, '2025-01-01 00:00:00', '2025-12-31 23:59:59', 500, 0, true, NOW()),
(3, 'SUMMER15', 'Summer special - 15% off all events', 'PERCENTAGE', 15.00, NULL, '2025-06-01 00:00:00', '2025-08-31 23:59:59', 200, 0, true, NOW()),
(4, 'FLAT50', 'Flat $50 off on orders above $200', 'FIXED_AMOUNT', 50.00, NULL, '2025-01-01 00:00:00', '2025-12-31 23:59:59', 150, 0, true, NOW()),
(5, 'TAYLOR10', 'Special discount for Taylor Swift concert', 'PERCENTAGE', 10.00, 1, '2025-01-01 00:00:00', '2025-03-14 23:59:59', 50, 0, true, NOW());

-- Insert Venue Sections for some events
INSERT INTO venue_sections (id, event_id, section_name, price_multiplier, total_seats, available_seats) VALUES
-- Taylor Swift sections
(1, 1, 'VIP Front', 2.0, 50, 45),
(2, 1, 'Orchestra', 1.5, 100, 90),
(3, 1, 'Mezzanine', 1.2, 150, 140),
(4, 1, 'Balcony', 1.0, 200, 175),

-- NBA Finals sections
(5, 7, 'Courtside', 3.0, 50, 45),
(6, 7, 'Lower Bowl', 2.0, 200, 185),
(7, 7, 'Club Level', 1.5, 250, 230),
(8, 7, 'Upper Bowl', 1.0, 300, 290);

-- Insert sample seats for Taylor Swift concert (Event ID: 1)
INSERT INTO seats (event_id, section_id, row_label, seat_number, status, price, booked_by, reserved_until) VALUES
-- VIP Front section
(1, 1, 'A', 1, 'AVAILABLE', 500.00, NULL, NULL),
(1, 1, 'A', 2, 'AVAILABLE', 500.00, NULL, NULL),
(1, 1, 'A', 3, 'AVAILABLE', 500.00, NULL, NULL),
(1, 1, 'A', 4, 'BOOKED', 500.00, 4, NULL),
(1, 1, 'A', 5, 'AVAILABLE', 500.00, NULL, NULL),
(1, 1, 'B', 1, 'AVAILABLE', 500.00, NULL, NULL),
(1, 1, 'B', 2, 'AVAILABLE', 500.00, NULL, NULL),
(1, 1, 'B', 3, 'RESERVED', 500.00, 5, DATE_ADD(NOW(), INTERVAL 15 MINUTE)),
(1, 1, 'B', 4, 'AVAILABLE', 500.00, NULL, NULL),
(1, 1, 'B', 5, 'AVAILABLE', 500.00, NULL, NULL),

-- Orchestra section
(1, 2, 'C', 1, 'AVAILABLE', 375.00, NULL, NULL),
(1, 2, 'C', 2, 'AVAILABLE', 375.00, NULL, NULL),
(1, 2, 'C', 3, 'AVAILABLE', 375.00, NULL, NULL),
(1, 2, 'C', 4, 'AVAILABLE', 375.00, NULL, NULL),
(1, 2, 'C', 5, 'BOOKED', 375.00, 6, NULL),
(1, 2, 'D', 1, 'AVAILABLE', 375.00, NULL, NULL),
(1, 2, 'D', 2, 'AVAILABLE', 375.00, NULL, NULL),
(1, 2, 'D', 3, 'AVAILABLE', 375.00, NULL, NULL),
(1, 2, 'D', 4, 'AVAILABLE', 375.00, NULL, NULL),
(1, 2, 'D', 5, 'AVAILABLE', 375.00, NULL, NULL);

-- Insert sample bookings
INSERT INTO bookings (id, booking_reference, booking_id, user_id, event_id, booking_date, booking_time, total_amount, discount_amount, final_amount, currency, payment_status, booking_status, payment_method, group_size, status, payment_time, transaction_id) VALUES
(1, 'BK20250001', 'BKID20250001', 4, 1, NOW(), NOW(), 500.00, 0.00, 500.00, 'USD', 'COMPLETED', 'CONFIRMED', 'CREDIT_CARD', 1, 'CONFIRMED', NOW(), 'TXN123456'),
(2, 'BK20250002', 'BKID20250002', 5, 1, NOW(), NOW(), 375.00, 0.00, 375.00, 'USD', 'PENDING', 'CONFIRMED', 'CREDIT_CARD', 1, 'CONFIRMED', NULL, NULL),
(3, 'BK20250003', 'BKID20250003', 6, 1, NOW(), NOW(), 375.00, 37.50, 337.50, 'USD', 'COMPLETED', 'CONFIRMED', 'DEBIT_CARD', 1, 'CONFIRMED', NOW(), 'TXN123457');

-- Update event available seats count
UPDATE events SET available_seats = available_seats - 3 WHERE id = 1;

-- Create indexes for better performance
CREATE INDEX idx_event_date ON events(event_date);
CREATE INDEX idx_event_type ON events(event_type);
CREATE INDEX idx_event_active ON events(active);
CREATE INDEX idx_user_email ON users(email);
CREATE INDEX idx_booking_user ON bookings(user_id);
CREATE INDEX idx_booking_event ON bookings(event_id);
CREATE INDEX idx_seat_event ON seats(event_id);
CREATE INDEX idx_seat_status ON seats(status);