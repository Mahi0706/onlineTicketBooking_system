-- Seed Data for Online Ticket Booking System
-- Password for all users is: password123

USE ticket_booking;

-- Disable foreign key checks for clean insertion
SET FOREIGN_KEY_CHECKS = 0;

-- Clear existing data
DELETE FROM booking_seats;
DELETE FROM bookings;
DELETE FROM reviews;
DELETE FROM waitlist;
DELETE FROM pricing_rules;
DELETE FROM seats;
DELETE FROM venue_sections;
DELETE FROM event_statistics;
DELETE FROM events;
DELETE FROM categories;
DELETE FROM notifications;
DELETE FROM user_preferences;
DELETE FROM users;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Insert Users with BCrypt password hash for 'password123'
INSERT INTO users (email, password, name, phone, role, is_active, preferred_language, preferred_currency, created_at, updated_at) VALUES
('admin@ticketbooking.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye/1lKmQ2Jz3JfAH5fWJzS8.UqNzenUWq', 'Admin User', '+1234567890', 'ADMIN', true, 'en', 'USD', NOW(), NOW()),
('john@organizer.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye/1lKmQ2Jz3JfAH5fWJzS8.UqNzenUWq', 'John Organizer', '+1234567891', 'ORGANIZER', true, 'en', 'USD', NOW(), NOW()),
('sarah@organizer.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye/1lKmQ2Jz3JfAH5fWJzS8.UqNzenUWq', 'Sarah Organizer', '+1234567892', 'ORGANIZER', true, 'en', 'USD', NOW(), NOW()),
('user@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye/1lKmQ2Jz3JfAH5fWJzS8.UqNzenUWq', 'Test User', '+1234567893', 'USER', true, 'en', 'USD', NOW(), NOW()),
('mike@user.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye/1lKmQ2Jz3JfAH5fWJzS8.UqNzenUWq', 'Mike Wilson', '+1234567894', 'USER', true, 'en', 'USD', NOW(), NOW()),
('emma@user.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye/1lKmQ2Jz3JfAH5fWJzS8.UqNzenUWq', 'Emma Davis', '+1234567895', 'USER', true, 'en', 'USD', NOW(), NOW());

-- Get user IDs
SET @admin_id = LAST_INSERT_ID();
SET @john_id = @admin_id + 1;
SET @sarah_id = @admin_id + 2;
SET @user_id = @admin_id + 3;
SET @mike_id = @admin_id + 4;
SET @emma_id = @admin_id + 5;

-- Insert Categories
INSERT INTO categories (name, description) VALUES
('Concert', 'Musical performances and concerts'),
('Movie', 'Film screenings and premieres'),
('Sports', 'Sporting events'),
('Theater', 'Theatre and stage performances'),
('Conference', 'Business and tech conferences');

-- Get category IDs
SET @cat_concert = LAST_INSERT_ID();
SET @cat_movie = @cat_concert + 1;
SET @cat_sports = @cat_concert + 2;
SET @cat_theater = @cat_concert + 3;
SET @cat_conference = @cat_concert + 4;

-- Insert Events (using proper column names)
INSERT INTO events (name, category_id, venue, address, event_date, price, currency, genre, type, description, image_url, total_seats, available_seats, featured, organizer_id, status, created_at, updated_at) VALUES
-- Concerts
('Rock Concert 2025', @cat_concert, 'Madison Square Garden', 'New York, NY', '2025-03-15 20:00:00', 75.00, 'USD', 'Rock', 'CONCERT', 'Amazing rock concert featuring top bands', NULL, 500, 500, false, @john_id, 'UPCOMING', NOW(), NOW()),
('Taylor Swift - Eras Tour', @cat_concert, 'MetLife Stadium', 'East Rutherford, NJ', '2025-04-20 19:30:00', 250.00, 'USD', 'Pop', 'CONCERT', 'Experience the magic of Taylor Swift live in concert', NULL, 1000, 1000, true, @john_id, 'UPCOMING', NOW(), NOW()),
('Jazz Night Special', @cat_concert, 'Blue Note', 'New York, NY', '2025-03-25 21:00:00', 65.00, 'USD', 'Jazz', 'CONCERT', 'An evening of smooth jazz with world-class musicians', NULL, 200, 200, false, @sarah_id, 'UPCOMING', NOW(), NOW()),
('Electronic Music Festival', @cat_concert, 'Brooklyn Warehouse', 'Brooklyn, NY', '2025-05-10 22:00:00', 90.00, 'USD', 'Electronic', 'CONCERT', 'All night electronic music party', NULL, 800, 800, true, @sarah_id, 'UPCOMING', NOW(), NOW()),

-- Movies
('The Avengers: Endgame Special', @cat_movie, 'AMC Theater', 'Los Angeles, CA', '2025-02-20 19:30:00', 25.00, 'USD', 'Action', 'MOVIE', 'Special IMAX screening with cast Q&A', NULL, 300, 300, false, @john_id, 'UPCOMING', NOW(), NOW()),
('Dune: Part Three', @cat_movie, 'TCL Chinese Theatre', 'Hollywood, CA', '2025-05-01 18:00:00', 30.00, 'USD', 'Sci-Fi', 'MOVIE', 'The epic conclusion to the Dune trilogy', NULL, 400, 400, true, @sarah_id, 'UPCOMING', NOW(), NOW()),
('Classic Movie Night', @cat_movie, 'Regal Cinema', 'Chicago, IL', '2025-03-10 20:00:00', 15.00, 'USD', 'Classic', 'MOVIE', 'Screening of cinema classics', NULL, 250, 250, false, @john_id, 'UPCOMING', NOW(), NOW()),

-- Sports
('NBA Finals Game 7', @cat_sports, 'Staples Center', 'Los Angeles, CA', '2025-06-20 21:00:00', 350.00, 'USD', 'Basketball', 'SPORTS', 'Championship deciding game', NULL, 1500, 1500, true, @john_id, 'UPCOMING', NOW(), NOW()),
('FIFA World Cup Qualifier', @cat_sports, 'Rose Bowl', 'Pasadena, CA', '2025-03-28 19:00:00', 120.00, 'USD', 'Soccer', 'SPORTS', 'USA vs Mexico qualifying match', NULL, 2000, 2000, true, @sarah_id, 'UPCOMING', NOW(), NOW()),
('Boxing Championship', @cat_sports, 'MGM Grand', 'Las Vegas, NV', '2025-04-15 22:00:00', 200.00, 'USD', 'Boxing', 'SPORTS', 'Heavyweight title fight', NULL, 800, 800, false, @john_id, 'UPCOMING', NOW(), NOW()),
('Tennis Grand Slam', @cat_sports, 'Arthur Ashe Stadium', 'New York, NY', '2025-09-05 14:00:00', 175.00, 'USD', 'Tennis', 'SPORTS', 'US Open Tennis Finals', NULL, 1200, 1200, true, @sarah_id, 'UPCOMING', NOW(), NOW()),

-- Theater
('Broadway: Hamilton', @cat_theater, 'Broadway Theater', 'New York, NY', '2025-04-10 19:00:00', 150.00, 'USD', 'Musical', 'THEATER', 'Award-winning musical about Alexander Hamilton', NULL, 500, 500, true, @sarah_id, 'UPCOMING', NOW(), NOW()),
('Shakespeare: Romeo and Juliet', @cat_theater, 'Globe Theatre', 'Boston, MA', '2025-05-05 19:30:00', 80.00, 'USD', 'Drama', 'THEATER', 'Classic romantic tragedy', NULL, 300, 300, false, @john_id, 'UPCOMING', NOW(), NOW()),
('The Lion King Musical', @cat_theater, 'Lyceum Theatre', 'New York, NY', '2025-06-01 20:00:00', 175.00, 'USD', 'Musical', 'THEATER', 'Disney Broadway spectacular', NULL, 600, 600, true, @sarah_id, 'UPCOMING', NOW(), NOW()),

-- Conferences
('Tech Conference 2025', @cat_conference, 'Convention Center', 'San Francisco, CA', '2025-09-15 09:00:00', 299.00, 'USD', 'Technology', 'CONFERENCE', 'Annual technology summit with industry leaders', NULL, 1000, 1000, true, @john_id, 'UPCOMING', NOW(), NOW()),
('Google I/O 2025', @cat_conference, 'Shoreline Amphitheatre', 'Mountain View, CA', '2025-05-07 10:00:00', 350.00, 'USD', 'Technology', 'CONFERENCE', 'Google developer conference', NULL, 800, 800, true, @sarah_id, 'UPCOMING', NOW(), NOW());

-- Get some event IDs for venue sections and seats
SET @taylor_event = (SELECT id FROM events WHERE name LIKE 'Taylor Swift%' LIMIT 1);
SET @nba_event = (SELECT id FROM events WHERE name LIKE 'NBA Finals%' LIMIT 1);
SET @hamilton_event = (SELECT id FROM events WHERE name LIKE 'Broadway: Hamilton%' LIMIT 1);

-- Insert Venue Sections for Taylor Swift concert
INSERT INTO venue_sections (event_id, section_name, price_multiplier, total_seats, available_seats) VALUES
(@taylor_event, 'VIP Front Row', 2.0, 50, 48),
(@taylor_event, 'Orchestra', 1.5, 200, 195),
(@taylor_event, 'Mezzanine', 1.2, 300, 295),
(@taylor_event, 'Balcony', 1.0, 450, 445);

-- Get venue section IDs
SET @vip_section = LAST_INSERT_ID();
SET @orchestra_section = @vip_section + 1;

-- Insert sample Seats for Taylor Swift concert
INSERT INTO seats (event_id, section_id, row_label, seat_number, status, price, booked_by, reserved_until) VALUES
-- VIP Section seats
(@taylor_event, @vip_section, 'A', 1, 'AVAILABLE', 500.00, NULL, NULL),
(@taylor_event, @vip_section, 'A', 2, 'AVAILABLE', 500.00, NULL, NULL),
(@taylor_event, @vip_section, 'A', 3, 'BOOKED', 500.00, @mike_id, NULL),
(@taylor_event, @vip_section, 'A', 4, 'AVAILABLE', 500.00, NULL, NULL),
(@taylor_event, @vip_section, 'A', 5, 'RESERVED', 500.00, @emma_id, DATE_ADD(NOW(), INTERVAL 15 MINUTE)),
-- Orchestra Section seats
(@taylor_event, @orchestra_section, 'B', 1, 'AVAILABLE', 375.00, NULL, NULL),
(@taylor_event, @orchestra_section, 'B', 2, 'AVAILABLE', 375.00, NULL, NULL),
(@taylor_event, @orchestra_section, 'B', 3, 'AVAILABLE', 375.00, NULL, NULL),
(@taylor_event, @orchestra_section, 'B', 4, 'BOOKED', 375.00, @user_id, NULL),
(@taylor_event, @orchestra_section, 'B', 5, 'AVAILABLE', 375.00, NULL, NULL);

-- Insert sample Bookings
INSERT INTO bookings (booking_reference, user_id, event_id, booking_date, total_amount, discount_amount, final_amount, currency, payment_status, booking_status, payment_method, group_size, notes) VALUES
('BK' + UNIX_TIMESTAMP(), @mike_id, @taylor_event, NOW(), 500.00, 50.00, 450.00, 'USD', 'SUCCESS', 'CONFIRMED', 'CREDIT_CARD', 1, 'VIP ticket purchase'),
('BK' + UNIX_TIMESTAMP() + 1, @user_id, @taylor_event, NOW(), 375.00, 0.00, 375.00, 'USD', 'SUCCESS', 'CONFIRMED', 'DEBIT_CARD', 1, 'Orchestra section booking'),
('BK' + UNIX_TIMESTAMP() + 2, @emma_id, @nba_event, NOW(), 350.00, 35.00, 315.00, 'USD', 'PENDING', 'CONFIRMED', 'PAYPAL', 1, 'NBA Finals ticket');

-- Insert sample Reviews
INSERT INTO reviews (event_id, user_id, rating, comment, created_at) VALUES
(@taylor_event, @mike_id, 5, 'Amazing concert! Best experience ever!', NOW()),
(@nba_event, @user_id, 4, 'Great game, exciting atmosphere', NOW()),
(@hamilton_event, @emma_id, 5, 'Brilliant performance, highly recommend!', NOW());

-- Insert Event Statistics
INSERT INTO event_statistics (event_id, total_views, total_bookings, total_revenue, last_updated) VALUES
(@taylor_event, 1500, 5, 2250.00, NOW()),
(@nba_event, 2000, 10, 3500.00, NOW()),
(@hamilton_event, 800, 3, 450.00, NOW());

-- Insert sample Notifications
INSERT INTO notifications (user_id, title, message, type, is_read, created_at) VALUES
(@mike_id, 'Booking Confirmed', 'Your booking for Taylor Swift concert has been confirmed!', 'BOOKING_CONFIRMATION', false, NOW()),
(@user_id, 'Payment Successful', 'Payment received for your booking', 'PAYMENT_SUCCESS', false, NOW()),
(@emma_id, 'Event Reminder', 'NBA Finals Game 7 is coming up soon!', 'EVENT_REMINDER', false, NOW());

-- Update events available seats
UPDATE events e SET e.available_seats = e.total_seats - (SELECT COUNT(*) FROM seats s WHERE s.event_id = e.id AND s.status = 'BOOKED') WHERE e.id IN (@taylor_event, @nba_event);

-- Summary
SELECT 'Database seeded successfully!' as Status;
SELECT
    (SELECT COUNT(*) FROM users) as Total_Users,
    (SELECT COUNT(*) FROM events) as Total_Events,
    (SELECT COUNT(*) FROM categories) as Total_Categories,
    (SELECT COUNT(*) FROM bookings) as Total_Bookings,
    (SELECT COUNT(*) FROM seats) as Total_Seats;