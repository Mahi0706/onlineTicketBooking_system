-- Fix user passwords with proper BCrypt hash for 'secret'
USE ticketbooking;

-- Update all user passwords with the correct BCrypt hash for 'secret'
-- This hash corresponds to the password 'secret'
UPDATE users
SET password = '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW'
WHERE email IN ('admin@ticketbooking.com', 'organizer@ticketbooking.com', 'user@ticketbooking.com');

-- Verify the update
SELECT id, email, first_name, last_name, role FROM users;