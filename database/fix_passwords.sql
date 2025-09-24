USE ticket_booking;

-- Update with the correct BCrypt hash for "secret"
-- This is the BCrypt hash for password "secret" with strength 10
UPDATE users SET password = '$2a$10$9dOxQXIdW9YmjqWdT8.xkeTv7dFHj6wPdaUh9OMYx.SZ7h.8rZu3O' WHERE email = 'user@ticketbooking.com';
UPDATE users SET password = '$2a$10$9dOxQXIdW9YmjqWdT8.xkeTv7dFHj6wPdaUh9OMYx.SZ7h.8rZu3O' WHERE email = 'admin@ticketbooking.com';
UPDATE users SET password = '$2a$10$9dOxQXIdW9YmjqWdT8.xkeTv7dFHj6wPdaUh9OMYx.SZ7h.8rZu3O' WHERE email = 'organizer@ticketbooking.com';

-- Verify
SELECT id, name, email, LEFT(password, 20) as password_preview FROM users WHERE email IN ('user@ticketbooking.com', 'admin@ticketbooking.com', 'organizer@ticketbooking.com');