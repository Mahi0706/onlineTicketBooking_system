CREATE DATABASE IF NOT EXISTS ticketbooking;
USE ticketbooking;

-- Create Users table
CREATE TABLE IF NOT EXISTS users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(50) NOT NULL DEFAULT 'USER',
    enabled BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email)
);

-- Create Events table
CREATE TABLE IF NOT EXISTS events (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    type VARCHAR(50),
    event_date TIMESTAMP NOT NULL,
    venue VARCHAR(255) NOT NULL,
    address VARCHAR(500),
    total_seats INT NOT NULL,
    available_seats INT,
    price DECIMAL(10, 2) NOT NULL,
    image_url VARCHAR(500),
    organizer_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (organizer_id) REFERENCES users(id),
    INDEX idx_event_date (event_date),
    INDEX idx_organizer (organizer_id)
);

-- Create Promotions table
CREATE TABLE IF NOT EXISTS promotions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) UNIQUE NOT NULL,
    description VARCHAR(255) NOT NULL,
    discount_type VARCHAR(50),
    discount_value DECIMAL(10, 2) NOT NULL,
    event_id BIGINT,
    valid_from TIMESTAMP,
    valid_until TIMESTAMP,
    max_usage INT,
    current_usage INT DEFAULT 0,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES events(id),
    INDEX idx_code (code),
    INDEX idx_event (event_id)
);

-- Create Bookings table
CREATE TABLE IF NOT EXISTS bookings (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    booking_id VARCHAR(100) UNIQUE NOT NULL,
    user_id BIGINT NOT NULL,
    event_id BIGINT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    discount_amount DECIMAL(10, 2) DEFAULT 0,
    final_amount DECIMAL(10, 2) NOT NULL,
    promotion_id BIGINT,
    status VARCHAR(50) DEFAULT 'PENDING',
    payment_status VARCHAR(50) DEFAULT 'PENDING',
    payment_method VARCHAR(50),
    transaction_id VARCHAR(100),
    qr_code TEXT,
    booking_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_time TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (event_id) REFERENCES events(id),
    FOREIGN KEY (promotion_id) REFERENCES promotions(id),
    INDEX idx_booking_id (booking_id),
    INDEX idx_user (user_id),
    INDEX idx_event (event_id)
);

-- Create Seats table
CREATE TABLE IF NOT EXISTS seats (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    event_id BIGINT NOT NULL,
    seat_number VARCHAR(20) NOT NULL,
    seat_row VARCHAR(10),
    section VARCHAR(50),
    status VARCHAR(20) DEFAULT 'AVAILABLE',
    booking_id BIGINT,
    FOREIGN KEY (event_id) REFERENCES events(id),
    FOREIGN KEY (booking_id) REFERENCES bookings(id),
    UNIQUE KEY unique_seat (event_id, seat_number),
    INDEX idx_event (event_id),
    INDEX idx_booking (booking_id),
    INDEX idx_status (status)
);

-- Insert sample data
-- Insert sample users
INSERT INTO users (email, password, first_name, last_name, phone, role) VALUES
('admin@ticketbooking.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'Admin', 'User', '1234567890', 'ADMIN'),
('organizer@ticketbooking.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'John', 'Organizer', '9876543210', 'ORGANIZER'),
('user@ticketbooking.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'Jane', 'Doe', '5555555555', 'USER');

-- Insert sample events
INSERT INTO events (name, description, type, event_date, venue, address, total_seats, available_seats, price, organizer_id) VALUES
('Rock Concert 2025', 'Amazing rock concert featuring top bands', 'CONCERT', '2025-03-15 20:00:00', 'Madison Square Garden', 'New York, NY', 500, 500, 75.00, 2),
('The Avengers: Endgame Special Screening', 'Special IMAX screening with cast Q&A', 'MOVIE', '2025-02-20 19:30:00', 'AMC Theater', 'Los Angeles, CA', 200, 200, 25.00, 2),
('NBA Finals Game 7', 'Championship deciding game', 'SPORTS', '2025-06-20 21:00:00', 'Staples Center', 'Los Angeles, CA', 1000, 1000, 250.00, 2),
('Broadway: Hamilton', 'Award-winning musical', 'THEATER', '2025-04-10 19:00:00', 'Broadway Theater', 'New York, NY', 300, 300, 150.00, 2);

-- Note: Default password for all users is 'secret' (bcrypt encrypted)