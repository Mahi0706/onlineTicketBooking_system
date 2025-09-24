-- Drop existing tables if they exist
DROP DATABASE IF EXISTS ticket_booking;
CREATE DATABASE ticket_booking;
USE ticket_booking;

-- Users table with roles
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('USER', 'ORGANIZER', 'ADMIN') DEFAULT 'USER',
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    preferred_language VARCHAR(10) DEFAULT 'en',
    preferred_currency VARCHAR(3) DEFAULT 'USD',
    INDEX idx_email (email),
    INDEX idx_role (role)
);

-- Event categories
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    icon VARCHAR(50),
    color VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Events table
CREATE TABLE events (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    category_id INT NOT NULL,
    venue VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    event_date DATE NOT NULL,
    event_time TIME NOT NULL,
    base_price DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    genre VARCHAR(100),
    description TEXT,
    image_url VARCHAR(500),
    total_seats INT NOT NULL,
    available_seats INT NOT NULL,
    featured BOOLEAN DEFAULT FALSE,
    organizer_id INT NOT NULL,
    status ENUM('UPCOMING', 'ONGOING', 'COMPLETED', 'CANCELLED') DEFAULT 'UPCOMING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (organizer_id) REFERENCES users(id),
    INDEX idx_date (event_date),
    INDEX idx_category (category_id),
    INDEX idx_featured (featured),
    INDEX idx_status (status)
);

-- Venue sections for pricing tiers
CREATE TABLE venue_sections (
    id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT NOT NULL,
    section_name VARCHAR(50) NOT NULL,
    price_multiplier DECIMAL(3, 2) DEFAULT 1.00,
    total_seats INT NOT NULL,
    available_seats INT NOT NULL,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    INDEX idx_event_section (event_id)
);

-- Individual seats
CREATE TABLE seats (
    id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT NOT NULL,
    section_id INT NOT NULL,
    row_label VARCHAR(10) NOT NULL,
    seat_number INT NOT NULL,
    status ENUM('AVAILABLE', 'RESERVED', 'BOOKED', 'BLOCKED') DEFAULT 'AVAILABLE',
    price DECIMAL(10, 2) NOT NULL,
    booked_by INT,
    reserved_until TIMESTAMP NULL,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    FOREIGN KEY (section_id) REFERENCES venue_sections(id) ON DELETE CASCADE,
    FOREIGN KEY (booked_by) REFERENCES users(id),
    UNIQUE KEY unique_seat (event_id, row_label, seat_number),
    INDEX idx_event_status (event_id, status),
    INDEX idx_reserved (reserved_until)
);

-- Bookings table
CREATE TABLE bookings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    booking_reference VARCHAR(20) UNIQUE NOT NULL,
    user_id INT NOT NULL,
    event_id INT NOT NULL,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    discount_amount DECIMAL(10, 2) DEFAULT 0,
    final_amount DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    payment_status ENUM('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED') DEFAULT 'PENDING',
    booking_status ENUM('CONFIRMED', 'CANCELLED', 'COMPLETED') DEFAULT 'CONFIRMED',
    payment_method VARCHAR(50),
    group_size INT DEFAULT 1,
    qr_code TEXT,
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (event_id) REFERENCES events(id),
    INDEX idx_user_bookings (user_id),
    INDEX idx_event_bookings (event_id),
    INDEX idx_booking_ref (booking_reference),
    INDEX idx_booking_date (booking_date)
);

-- Booking seats mapping
CREATE TABLE booking_seats (
    id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    seat_id INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE,
    FOREIGN KEY (seat_id) REFERENCES seats(id),
    UNIQUE KEY unique_booking_seat (booking_id, seat_id)
);

-- Reviews and ratings
CREATE TABLE reviews (
    id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT NOT NULL,
    user_id INT NOT NULL,
    booking_id INT,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_verified BOOLEAN DEFAULT FALSE,
    helpful_count INT DEFAULT 0,
    FOREIGN KEY (event_id) REFERENCES events(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (booking_id) REFERENCES bookings(id),
    UNIQUE KEY unique_user_event_review (user_id, event_id),
    INDEX idx_event_reviews (event_id),
    INDEX idx_rating (rating)
);

-- Waitlist for sold-out events
CREATE TABLE waitlist (
    id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT NOT NULL,
    user_id INT NOT NULL,
    requested_seats INT DEFAULT 1,
    priority INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notified BOOLEAN DEFAULT FALSE,
    notified_at TIMESTAMP NULL,
    status ENUM('WAITING', 'NOTIFIED', 'CONVERTED', 'EXPIRED') DEFAULT 'WAITING',
    FOREIGN KEY (event_id) REFERENCES events(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    UNIQUE KEY unique_waitlist (event_id, user_id),
    INDEX idx_event_waitlist (event_id, status),
    INDEX idx_user_waitlist (user_id)
);

-- Event recommendations (for ML/recommendation system)
CREATE TABLE user_preferences (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    category_id INT NOT NULL,
    preference_score DECIMAL(3, 2) DEFAULT 0.5,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (category_id) REFERENCES categories(id),
    UNIQUE KEY unique_user_category (user_id, category_id)
);

-- Dynamic pricing rules
CREATE TABLE pricing_rules (
    id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT NOT NULL,
    rule_type ENUM('OCCUPANCY', 'TIME_BASED', 'DAY_OF_WEEK', 'GROUP_DISCOUNT') NOT NULL,
    threshold_value DECIMAL(10, 2),
    multiplier DECIMAL(3, 2),
    discount_percentage DECIMAL(5, 2),
    min_group_size INT,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES events(id),
    INDEX idx_event_rules (event_id, active)
);

-- Notifications
CREATE TABLE notifications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    type ENUM('BOOKING_CONFIRMATION', 'EVENT_REMINDER', 'WAITLIST_AVAILABLE', 'PRICE_DROP', 'NEW_REVIEW') NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT,
    event_id INT,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (event_id) REFERENCES events(id),
    INDEX idx_user_notifications (user_id, is_read),
    INDEX idx_created (created_at)
);

-- Admin statistics view
CREATE VIEW event_statistics AS
SELECT
    e.id,
    e.title,
    e.event_date,
    COUNT(DISTINCT b.id) as total_bookings,
    COUNT(DISTINCT bs.seat_id) as seats_sold,
    e.total_seats - e.available_seats as seats_booked,
    SUM(b.final_amount) as total_revenue,
    AVG(r.rating) as avg_rating,
    COUNT(DISTINCT r.id) as total_reviews,
    COUNT(DISTINCT w.id) as waitlist_count
FROM events e
LEFT JOIN bookings b ON e.id = b.event_id AND b.booking_status = 'CONFIRMED'
LEFT JOIN booking_seats bs ON b.id = bs.booking_id
LEFT JOIN reviews r ON e.id = r.event_id
LEFT JOIN waitlist w ON e.id = w.event_id AND w.status = 'WAITING'
GROUP BY e.id;

-- Insert initial data
INSERT INTO categories (name, icon, color) VALUES
('concert', 'FaMusic', 'purple'),
('movie', 'FaFilm', 'blue'),
('sports', 'FaBasketballBall', 'orange'),
('theater', 'FaTheaterMasks', 'pink');

-- Insert demo users
INSERT INTO users (name, email, password, role) VALUES
('Demo User', 'user@ticketbooking.com', '$2a$10$YourHashedPasswordHere', 'USER'),
('Demo Organizer', 'organizer@ticketbooking.com', '$2a$10$YourHashedPasswordHere', 'ORGANIZER'),
('Demo Admin', 'admin@ticketbooking.com', '$2a$10$YourHashedPasswordHere', 'ADMIN'),
('Live Nation', 'livenation@ticketbooking.com', '$2a$10$YourHashedPasswordHere', 'ORGANIZER'),
('BookMyShow', 'bookmyshow@ticketbooking.com', '$2a$10$YourHashedPasswordHere', 'ORGANIZER');

-- Insert events
INSERT INTO events (title, category_id, venue, location, event_date, event_time, base_price, genre, description, image_url, total_seats, available_seats, featured, organizer_id) VALUES
('Coldplay – Music of the Spheres World Tour', 1, 'Wembley Stadium', 'London', '2025-10-12', '19:00:00', 120.00, 'Rock/Pop', 'Experience the magical Music of the Spheres World Tour by Coldplay. An unforgettable night filled with hits, stunning visuals, and eco-friendly production.', 'https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?w=800', 500, 127, TRUE, 4),
('Arijit Singh Live 2025', 1, 'Jio World Garden', 'Mumbai', '2025-11-05', '20:00:00', 30.00, 'Bollywood', 'The voice of romance returns! Arijit Singh brings his soulful melodies to Mumbai for an evening of unforgettable Bollywood hits.', 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800', 400, 89, TRUE, 5),
('Avatar 3 – IMAX Special', 2, 'AMC Metreon', 'San Francisco', '2025-12-20', '18:30:00', 25.00, 'Sci-Fi', 'James Cameron returns with Avatar 3. Experience Pandora like never before in stunning IMAX 3D.', 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=800', 300, 234, TRUE, 5),
('Pushpa 2 – The Rule Premiere Show', 2, 'PVR Cinemas', 'Hyderabad', '2025-10-05', '21:00:00', 5.00, 'Action/Drama', 'Allu Arjun returns as Pushpa Raj in this highly anticipated sequel. Witness the rule of Pushpa in this action-packed drama.', 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=800', 250, 12, FALSE, 5),
('NBA Finals Game 1', 3, 'Madison Square Garden', 'New York', '2025-06-15', '20:00:00', 250.00, 'Basketball', 'Be part of history at the NBA Finals Game 1. Watch the best teams battle for the championship.', 'https://images.unsplash.com/photo-1504450758481-7338eba7524a?w=800', 600, 45, TRUE, 4),
('India vs Australia – T20 Match', 3, 'M. Chinnaswamy Stadium', 'Bangalore', '2025-09-25', '19:30:00', 18.00, 'Cricket', 'Witness the thrilling T20 encounter between India and Australia at the iconic Chinnaswamy Stadium.', 'https://images.unsplash.com/photo-1531415074968-036ba1b575da?w=800', 800, 267, FALSE, 4),
('Hamilton – Broadway Musical', 4, 'Broadway Theatre', 'New York', '2025-11-10', '19:00:00', 180.00, 'Musical', 'The award-winning musical that tells the story of America then, as told by America now.', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800', 350, 78, TRUE, 4),
('Mughal-e-Azam – The Musical', 4, 'Siri Fort Auditorium', 'Delhi', '2025-12-05', '19:30:00', 24.00, 'Historical Drama', 'The legendary love story of Salim and Anarkali comes alive on stage with spectacular sets and performances.', 'https://images.unsplash.com/photo-1503095396549-807759245b35?w=800', 400, 189, FALSE, 5);

-- Create sections for each event
INSERT INTO venue_sections (event_id, section_name, price_multiplier, total_seats, available_seats)
SELECT
    e.id,
    'Premium',
    1.5,
    FLOOR(e.total_seats * 0.2),
    FLOOR(e.available_seats * 0.2)
FROM events e
UNION ALL
SELECT
    e.id,
    'Standard',
    1.2,
    FLOOR(e.total_seats * 0.3),
    FLOOR(e.available_seats * 0.3)
FROM events e
UNION ALL
SELECT
    e.id,
    'Regular',
    1.0,
    FLOOR(e.total_seats * 0.5),
    FLOOR(e.available_seats * 0.5)
FROM events e;

-- Add some sample reviews
INSERT INTO reviews (event_id, user_id, rating, review_text, is_verified) VALUES
(1, 1, 5, 'Amazing concert! The visuals were spectacular and the sound quality was perfect.', TRUE),
(1, 2, 4, 'Great show but the venue was a bit crowded. Still worth it!', TRUE),
(2, 1, 5, 'Arijit Singh voice is magical live. Goosebumps throughout!', TRUE),
(3, 1, 4, 'IMAX experience was worth the price. Cant wait for the movie!', FALSE);

-- Add pricing rules for dynamic pricing
INSERT INTO pricing_rules (event_id, rule_type, threshold_value, multiplier) VALUES
(1, 'OCCUPANCY', 80.00, 1.20),  -- 20% price increase when 80% full
(1, 'TIME_BASED', 7.00, 1.15),   -- 15% increase 7 days before event
(2, 'OCCUPANCY', 75.00, 1.15),
(3, 'OCCUPANCY', 90.00, 1.25);

-- Add group discount rules
INSERT INTO pricing_rules (event_id, rule_type, min_group_size, discount_percentage) VALUES
(1, 'GROUP_DISCOUNT', 5, 10.00),   -- 10% off for 5+ tickets
(1, 'GROUP_DISCOUNT', 10, 15.00),  -- 15% off for 10+ tickets
(2, 'GROUP_DISCOUNT', 5, 10.00),
(3, 'GROUP_DISCOUNT', 5, 10.00);

-- Create indexes for performance
CREATE INDEX idx_events_title ON events(title);
CREATE INDEX idx_events_venue ON events(venue);
CREATE INDEX idx_events_location ON events(location);
CREATE INDEX idx_bookings_date_range ON bookings(booking_date, event_id);
CREATE INDEX idx_seats_availability ON seats(event_id, status, section_id);