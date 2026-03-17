-- Update seed user passwords to bcrypt hash of 'password123'
-- BCrypt $2b$ is compatible with Spring Security's BCryptPasswordEncoder
UPDATE users SET password = '$2b$10$AAG5r9xd9V2dW0Cz1mnpLeDJjSbj54DeO2g7HaHoea0clL0CxJLRK'
WHERE password = '$2a$10$placeholder';
