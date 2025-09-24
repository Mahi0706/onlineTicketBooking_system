-- Fix the password column length and update with proper BCrypt hash
USE ticketbooking;

-- Ensure password column can store full BCrypt hash (60 characters)
ALTER TABLE users MODIFY COLUMN password VARCHAR(100);

-- Update with a valid BCrypt hash for 'secret'
UPDATE users
SET password = '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW'
WHERE email IN ('admin@ticketbooking.com', 'organizer@ticketbooking.com', 'user@ticketbooking.com');

-- Verify the update
SELECT email, LENGTH(password) as pwd_len, password FROM users;