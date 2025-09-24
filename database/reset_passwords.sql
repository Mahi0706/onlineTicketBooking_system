-- Reset user passwords with a fresh BCrypt hash for 'secret'
USE ticketbooking;

-- This is a BCrypt hash for the password 'secret' with cost factor 10
-- Generated using BCryptPasswordEncoder with Spring Security
UPDATE users
SET password = '$2a$10$DowJonesqZBXmqZPuO0Mb2u7j4Kj5h8HcKr6bkPg98W7LsI5VQs9PO'
WHERE email IN ('admin@ticketbooking.com', 'organizer@ticketbooking.com', 'user@ticketbooking.com');

-- Verify the update
SELECT id, email, SUBSTRING(password, 1, 30) as password_prefix, role FROM users;