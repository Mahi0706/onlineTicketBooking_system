-- Initialize Database with Seed Data
-- BCrypt hash for 'password123' is: $2a$10$N9qo8uLOickgx2ZMRZoMye/1lKmQ2Jz3JfAH5fWJzS8.UqNzenUWq

USE ticket_booking;

-- Clear existing data
SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM booking_seats_mapping;
DELETE FROM bookings;
DELETE FROM seats;
DELETE FROM venue_sections;
DELETE FROM events;
DELETE FROM categories;
DELETE FROM promotions;
DELETE FROM users;
SET FOREIGN_KEY_CHECKS = 1;

-- Insert Users (password for all users is 'password123')
INSERT INTO users (email, password, name, first_name, last_name, phone, role, is_active, preferred_language, preferred_currency, created_at, updated_at) VALUES
('admin@ticketbooking.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye/1lKmQ2Jz3JfAH5fWJzS8.UqNzenUWq', 'Admin User', 'Admin', 'User', '+1234567890', 'ADMIN', true, 'en', 'USD', NOW(), NOW()),
('john@organizer.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye/1lKmQ2Jz3JfAH5fWJzS8.UqNzenUWq', 'John Smith', 'John', 'Smith', '+1234567891', 'ORGANIZER', true, 'en', 'USD', NOW(), NOW()),
('sarah@organizer.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye/1lKmQ2Jz3JfAH5fWJzS8.UqNzenUWq', 'Sarah Johnson', 'Sarah', 'Johnson', '+1234567892', 'ORGANIZER', true, 'en', 'USD', NOW(), NOW()),
('mike@user.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye/1lKmQ2Jz3JfAH5fWJzS8.UqNzenUWq', 'Mike Wilson', 'Mike', 'Wilson', '+1234567893', 'USER', true, 'en', 'USD', NOW(), NOW()),
('emma@user.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye/1lKmQ2Jz3JfAH5fWJzS8.UqNzenUWq', 'Emma Davis', 'Emma', 'Davis', '+1234567894', 'USER', true, 'en', 'USD', NOW(), NOW()),
('david@user.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye/1lKmQ2Jz3JfAH5fWJzS8.UqNzenUWq', 'David Brown', 'David', 'Brown', '+1234567895', 'USER', true, 'en', 'USD', NOW(), NOW()),
('test@user.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye/1lKmQ2Jz3JfAH5fWJzS8.UqNzenUWq', 'Test User', 'Test', 'User', '+1234567896', 'USER', true, 'en', 'USD', NOW(), NOW());

-- Get user IDs for reference
SET @admin_id = (SELECT id FROM users WHERE email = 'admin@ticketbooking.com');
SET @john_id = (SELECT id FROM users WHERE email = 'john@organizer.com');
SET @sarah_id = (SELECT id FROM users WHERE email = 'sarah@organizer.com');
SET @mike_id = (SELECT id FROM users WHERE email = 'mike@user.com');
SET @emma_id = (SELECT id FROM users WHERE email = 'emma@user.com');

-- Insert Categories (if table exists)
CREATE TABLE IF NOT EXISTS categories (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255)
);

INSERT INTO categories (name, description) VALUES
('CONCERT', 'Musical concerts and live performances'),
('MOVIE', 'Movie screenings and premieres'),
('SPORTS', 'Sports events and matches'),
('THEATER', 'Theater plays and musicals'),
('CONFERENCE', 'Business and tech conferences'),
('COMEDY', 'Stand-up comedy shows');

-- Insert Events with proper field names
INSERT INTO events (name, description, event_type, event_date, venue, address, total_seats, available_seats, price, organizer_id, created_at, updated_at, active, currency, genre, status) VALUES
-- Concerts
('Taylor Swift - Eras Tour', 'Experience the spectacular Eras Tour featuring hits from Taylor Swift entire career', 'CONCERT', '2025-03-15 19:30:00', 'MetLife Stadium', 'East Rutherford, NJ', 500, 485, 250.00, @john_id, NOW(), NOW(), true, 'USD', 'Pop', 'UPCOMING'),
('Ed Sheeran Live 2025', 'An intimate evening with Ed Sheeran performing his greatest hits', 'CONCERT', '2025-04-20 20:00:00', 'Madison Square Garden', 'New York, NY', 400, 395, 180.00, @john_id, NOW(), NOW(), true, 'USD', 'Pop', 'UPCOMING'),
('Metallica World Tour', 'Heavy metal legends Metallica bring their explosive show', 'CONCERT', '2025-05-10 19:00:00', 'Staples Center', 'Los Angeles, CA', 600, 595, 150.00, @sarah_id, NOW(), NOW(), true, 'USD', 'Metal', 'UPCOMING'),
('The Weeknd - After Hours Tour', 'The Weeknd brings his cinematic performance to life', 'CONCERT', '2025-06-05 20:00:00', 'Oracle Arena', 'Oakland, CA', 450, 440, 200.00, @john_id, NOW(), NOW(), true, 'USD', 'R&B', 'UPCOMING'),

-- Movies
('Dune: Part Three - Premiere', 'Exclusive premiere screening of the epic conclusion to the Dune trilogy', 'MOVIE', '2025-03-01 19:00:00', 'TCL Chinese Theatre', 'Hollywood, CA', 300, 290, 50.00, @john_id, NOW(), NOW(), true, 'USD', 'Sci-Fi', 'UPCOMING'),
('Marvel Studios: Avengers 5', 'First screening of the next Avengers movie', 'MOVIE', '2025-05-05 18:30:00', 'AMC Times Square', 'New York, NY', 250, 240, 35.00, @sarah_id, NOW(), NOW(), true, 'USD', 'Action', 'UPCOMING'),
('Christopher Nolan New Film', 'Mystery premiere of Christopher Nolan latest masterpiece', 'MOVIE', '2025-07-20 20:00:00', 'IMAX Theater', 'Los Angeles, CA', 200, 195, 45.00, @john_id, NOW(), NOW(), true, 'USD', 'Thriller', 'UPCOMING'),
('Oppenheimer 2', 'The sequel to the Academy Award winning film', 'MOVIE', '2025-08-15 19:30:00', 'Dolby Theater', 'Los Angeles, CA', 280, 275, 40.00, @sarah_id, NOW(), NOW(), true, 'USD', 'Drama', 'UPCOMING'),

-- Sports
('NBA Finals - Game 7', 'The championship deciding game of the NBA Finals', 'SPORTS', '2025-06-15 21:00:00', 'Chase Center', 'San Francisco, CA', 800, 780, 350.00, @sarah_id, NOW(), NOW(), true, 'USD', 'Basketball', 'UPCOMING'),
('FIFA World Cup Qualifier', 'USA vs Mexico - World Cup qualifying match', 'SPORTS', '2025-03-28 19:00:00', 'Rose Bowl', 'Pasadena, CA', 1000, 980, 120.00, @john_id, NOW(), NOW(), true, 'USD', 'Soccer', 'UPCOMING'),
('Super Bowl LX', 'The biggest game in American football', 'SPORTS', '2026-02-07 18:30:00', 'SoFi Stadium', 'Los Angeles, CA', 700, 690, 500.00, @sarah_id, NOW(), NOW(), true, 'USD', 'Football', 'UPCOMING'),
('UFC 300 - Championship Night', 'Mixed martial arts championship fights', 'SPORTS', '2025-04-25 22:00:00', 'T-Mobile Arena', 'Las Vegas, NV', 550, 540, 275.00, @john_id, NOW(), NOW(), true, 'USD', 'MMA', 'UPCOMING'),

-- Theater
('Hamilton - Broadway', 'The award-winning musical about Alexander Hamilton', 'THEATER', '2025-04-10 19:30:00', 'Richard Rodgers Theatre', 'New York, NY', 350, 330, 200.00, @john_id, NOW(), NOW(), true, 'USD', 'Musical', 'UPCOMING'),
('The Lion King Musical', 'Disney spectacular musical adaptation', 'THEATER', '2025-05-15 20:00:00', 'Lyceum Theatre', 'New York, NY', 400, 385, 180.00, @sarah_id, NOW(), NOW(), true, 'USD', 'Musical', 'UPCOMING'),
('Shakespeare: Hamlet', 'Classic performance of Shakespeare timeless tragedy', 'THEATER', '2025-06-20 19:00:00', 'Globe Theatre', 'Boston, MA', 300, 290, 90.00, @john_id, NOW(), NOW(), true, 'USD', 'Drama', 'UPCOMING'),
('Wicked - The Musical', 'The untold story of the Witches of Oz', 'THEATER', '2025-07-08 19:30:00', 'Gershwin Theatre', 'New York, NY', 380, 370, 165.00, @sarah_id, NOW(), NOW(), true, 'USD', 'Musical', 'UPCOMING'),

-- Conferences
('TechCrunch Disrupt 2025', 'Premier technology conference featuring startups and innovations', 'CONFERENCE', '2025-09-20 09:00:00', 'Moscone Center', 'San Francisco, CA', 500, 480, 450.00, @sarah_id, NOW(), NOW(), true, 'USD', 'Technology', 'UPCOMING'),
('Google I/O 2025', 'Google annual developer conference', 'CONFERENCE', '2025-05-07 10:00:00', 'Shoreline Amphitheatre', 'Mountain View, CA', 600, 585, 350.00, @john_id, NOW(), NOW(), true, 'USD', 'Technology', 'UPCOMING'),
('AWS re:Invent 2025', 'Amazon Web Services global cloud computing conference', 'CONFERENCE', '2025-11-29 09:00:00', 'Las Vegas Convention Center', 'Las Vegas, NV', 750, 740, 400.00, @sarah_id, NOW(), NOW(), true, 'USD', 'Cloud Computing', 'UPCOMING'),

-- Comedy & Others
('Dave Chappelle Live', 'Stand-up comedy special with Dave Chappelle', 'OTHER', '2025-04-01 20:00:00', 'Comedy Store', 'Los Angeles, CA', 200, 180, 80.00, @sarah_id, NOW(), NOW(), true, 'USD', 'Comedy', 'UPCOMING'),
('Kevin Hart: Reality Check Tour', 'Kevin Hart brings his hilarious new material', 'OTHER', '2025-05-22 21:00:00', 'The Forum', 'Los Angeles, CA', 350, 340, 95.00, @john_id, NOW(), NOW(), true, 'USD', 'Comedy', 'UPCOMING');

-- Insert Promotions
INSERT INTO promotions (code, description, discount_type, discount_value, event_id, valid_from, valid_until, max_usage, current_usage, active, created_at) VALUES
('WELCOME10', 'Welcome discount - 10% off your first booking', 'PERCENTAGE', 10.00, NULL, '2025-01-01 00:00:00', '2025-12-31 23:59:59', 1000, 15, true, NOW()),
('EARLY2025', 'Early bird discount for 2025 events', 'PERCENTAGE', 20.00, NULL, '2025-01-01 00:00:00', '2025-02-28 23:59:59', 100, 5, true, NOW()),
('STUDENT20', 'Student discount - 20% off', 'PERCENTAGE', 20.00, NULL, '2025-01-01 00:00:00', '2025-12-31 23:59:59', 500, 25, true, NOW()),
('SUMMER15', 'Summer special - 15% off all events', 'PERCENTAGE', 15.00, NULL, '2025-06-01 00:00:00', '2025-08-31 23:59:59', 200, 0, true, NOW()),
('FLAT50', 'Flat $50 off on orders above $200', 'FIXED_AMOUNT', 50.00, NULL, '2025-01-01 00:00:00', '2025-12-31 23:59:59', 150, 10, true, NOW()),
('WEEKEND25', 'Weekend special - 25% off Friday to Sunday events', 'PERCENTAGE', 25.00, NULL, '2025-01-01 00:00:00', '2025-12-31 23:59:59', 300, 8, true, NOW()),
('GROUP10', 'Group booking discount - 10% off for 4+ tickets', 'PERCENTAGE', 10.00, NULL, '2025-01-01 00:00:00', '2025-12-31 23:59:59', 200, 12, true, NOW());

-- Get some event IDs for creating seats and bookings
SET @taylor_id = (SELECT id FROM events WHERE name LIKE 'Taylor Swift%' LIMIT 1);
SET @nba_id = (SELECT id FROM events WHERE name LIKE 'NBA Finals%' LIMIT 1);
SET @hamilton_id = (SELECT id FROM events WHERE name LIKE 'Hamilton%' LIMIT 1);

-- Insert sample seats for Taylor Swift concert
INSERT INTO seats (event_id, section_id, row_label, seat_number, status, price, booked_by, reserved_until) VALUES
-- First 20 seats
(@taylor_id, NULL, 'A', 1, 'AVAILABLE', 250.00, NULL, NULL),
(@taylor_id, NULL, 'A', 2, 'AVAILABLE', 250.00, NULL, NULL),
(@taylor_id, NULL, 'A', 3, 'BOOKED', 250.00, @mike_id, NULL),
(@taylor_id, NULL, 'A', 4, 'BOOKED', 250.00, @mike_id, NULL),
(@taylor_id, NULL, 'A', 5, 'AVAILABLE', 250.00, NULL, NULL),
(@taylor_id, NULL, 'B', 1, 'AVAILABLE', 250.00, NULL, NULL),
(@taylor_id, NULL, 'B', 2, 'RESERVED', 250.00, @emma_id, DATE_ADD(NOW(), INTERVAL 15 MINUTE)),
(@taylor_id, NULL, 'B', 3, 'AVAILABLE', 250.00, NULL, NULL),
(@taylor_id, NULL, 'B', 4, 'AVAILABLE', 250.00, NULL, NULL),
(@taylor_id, NULL, 'B', 5, 'AVAILABLE', 250.00, NULL, NULL);

-- Insert sample bookings
INSERT INTO bookings (booking_reference, booking_id, user_id, event_id, booking_date, booking_time, total_amount, discount_amount, final_amount, currency, payment_status, booking_status, payment_method, group_size, status, payment_time, transaction_id) VALUES
('BK202501001', 'BKID202501001', @mike_id, @taylor_id, NOW(), NOW(), 500.00, 50.00, 450.00, 'USD', 'SUCCESS', 'CONFIRMED', 'CREDIT_CARD', 2, 'CONFIRMED', NOW(), 'TXN10001'),
('BK202501002', 'BKID202501002', @emma_id, @nba_id, NOW(), NOW(), 350.00, 0.00, 350.00, 'USD', 'PENDING', 'CONFIRMED', 'DEBIT_CARD', 1, 'CONFIRMED', NULL, NULL),
('BK202501003', 'BKID202501003', @mike_id, @hamilton_id, NOW(), NOW(), 400.00, 40.00, 360.00, 'USD', 'SUCCESS', 'CONFIRMED', 'PAYPAL', 2, 'CONFIRMED', NOW(), 'TXN10003');

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_event_date ON events(event_date);
CREATE INDEX IF NOT EXISTS idx_event_type ON events(event_type);
CREATE INDEX IF NOT EXISTS idx_event_active ON events(active);
CREATE INDEX IF NOT EXISTS idx_user_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_booking_user ON bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_booking_event ON bookings(event_id);

-- Display summary
SELECT 'Data insertion completed!' as Status;
SELECT COUNT(*) as total_users FROM users;
SELECT COUNT(*) as total_events FROM events;
SELECT COUNT(*) as total_promotions FROM promotions;
SELECT COUNT(*) as total_bookings FROM bookings;