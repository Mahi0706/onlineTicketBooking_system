-- Add new events to the ticketbooking database
USE ticketbooking;

-- Add new concert events
INSERT INTO events (name, description, type, event_date, venue, address, total_seats, available_seats, price, organizer_id) VALUES
('Coldplay – Music of the Spheres World Tour', 'Experience the spectacular Music of the Spheres World Tour featuring stunning visuals and classic Coldplay hits', 'CONCERT', '2025-10-12 19:00:00', 'Wembley Stadium', 'London, UK', 800, 800, 120.00, 2),
('Arijit Singh Live 2025', 'An evening with India\'s most beloved playback singer performing his greatest Bollywood hits', 'CONCERT', '2025-11-05 20:00:00', 'Jio World Garden', 'Mumbai, Maharashtra, India', 600, 600, 2500.00, 2),

-- Add new movie events
('Avatar 3 – IMAX Special', 'Special IMAX screening of James Cameron\'s Avatar 3 with exclusive behind-the-scenes content', 'MOVIE', '2025-12-20 18:30:00', 'AMC Metreon', 'San Francisco, CA, USA', 300, 300, 25.00, 2),
('Pushpa 2 – The Rule Premiere Show', 'Premiere show of the highly anticipated sequel starring Allu Arjun in action-packed drama', 'MOVIE', '2025-10-05 21:00:00', 'PVR Cinemas', 'Hyderabad, Telangana, India', 250, 250, 400.00, 2),

-- Add new sports events
('NBA Finals Game 1', 'Opening game of the NBA Finals championship series at the iconic Madison Square Garden', 'SPORTS', '2025-06-15 20:00:00', 'Madison Square Garden', 'New York, NY, USA', 1200, 1200, 250.00, 2),
('India vs Australia – T20 Match', 'Exciting T20 cricket match between India and Australia at the Chinnaswamy Stadium', 'SPORTS', '2025-09-25 19:30:00', 'M. Chinnaswamy Stadium', 'Bangalore, Karnataka, India', 1500, 1500, 1500.00, 2),

-- Add new theater events
('Hamilton – Broadway Musical', 'The award-winning musical about Alexander Hamilton featuring hip-hop music and revolutionary storytelling', 'THEATER', '2025-11-10 19:00:00', 'Broadway Theatre', 'New York, NY, USA', 400, 400, 180.00, 2),
('Mughal-e-Azam – The Musical', 'Grand musical adaptation of the classic Bollywood film depicting Mughal era romance and drama', 'THEATER', '2025-12-05 19:30:00', 'Siri Fort Auditorium', 'Delhi, India', 350, 350, 2000.00, 2);

-- Create seats for each new event
-- Note: Event IDs will be auto-generated, so we'll use a subquery to get them

-- Create seats for Coldplay concert (ID will be determined by the insert order)
INSERT INTO seats (event_id, seat_number, seat_row, section, status)
SELECT id, CONCAT('A', n), 'A', 'VIP', 'AVAILABLE'
FROM events, (SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
              UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) numbers
WHERE name = 'Coldplay – Music of the Spheres World Tour'
LIMIT 10;

-- Create seats for Arijit Singh concert
INSERT INTO seats (event_id, seat_number, seat_row, section, status)
SELECT id, CONCAT('B', n), 'B', 'Premium', 'AVAILABLE'
FROM events, (SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
              UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) numbers
WHERE name = 'Arijit Singh Live 2025'
LIMIT 10;

-- Create seats for Avatar 3
INSERT INTO seats (event_id, seat_number, seat_row, section, status)
SELECT id, CONCAT('C', n), 'C', 'IMAX', 'AVAILABLE'
FROM events, (SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
              UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) numbers
WHERE name = 'Avatar 3 – IMAX Special'
LIMIT 10;

-- Create seats for Pushpa 2
INSERT INTO seats (event_id, seat_number, seat_row, section, status)
SELECT id, CONCAT('D', n), 'D', 'Gold', 'AVAILABLE'
FROM events, (SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
              UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) numbers
WHERE name = 'Pushpa 2 – The Rule Premiere Show'
LIMIT 10;

-- Create seats for NBA Finals
INSERT INTO seats (event_id, seat_number, seat_row, section, status)
SELECT id, CONCAT('E', n), 'E', 'Courtside', 'AVAILABLE'
FROM events, (SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
              UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) numbers
WHERE name = 'NBA Finals Game 1'
LIMIT 10;

-- Create seats for India vs Australia
INSERT INTO seats (event_id, seat_number, seat_row, section, status)
SELECT id, CONCAT('F', n), 'F', 'Pavilion', 'AVAILABLE'
FROM events, (SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
              UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) numbers
WHERE name = 'India vs Australia – T20 Match'
LIMIT 10;

-- Create seats for Hamilton
INSERT INTO seats (event_id, seat_number, seat_row, section, status)
SELECT id, CONCAT('G', n), 'G', 'Orchestra', 'AVAILABLE'
FROM events, (SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
              UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) numbers
WHERE name = 'Hamilton – Broadway Musical'
LIMIT 10;

-- Create seats for Mughal-e-Azam
INSERT INTO seats (event_id, seat_number, seat_row, section, status)
SELECT id, CONCAT('H', n), 'H', 'Balcony', 'AVAILABLE'
FROM events, (SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
              UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) numbers
WHERE name = 'Mughal-e-Azam – The Musical'
LIMIT 10;

-- Verify the new events were added
SELECT COUNT(*) as total_events FROM events;
SELECT name, type, venue, event_date, price FROM events ORDER BY event_date;