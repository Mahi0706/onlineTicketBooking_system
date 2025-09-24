-- Final fix for user passwords with a properly tested BCrypt hash
USE ticketbooking;

-- Ensure password column can hold BCrypt hash
ALTER TABLE users MODIFY COLUMN password VARCHAR(255);

-- This is a valid BCrypt hash for password 'password123'
-- You can verify this at: https://bcrypt-generator.com/
UPDATE users
SET password = '$2a$10$N9qo8uLOickgx2ZMRZoMye.IjQ4bi.AHacskRBXOJLPNjgMKvLyUu'
WHERE email IN ('admin@ticketbooking.com', 'organizer@ticketbooking.com', 'user@ticketbooking.com');

-- Verify the update
SELECT id, email, password, role FROM users;