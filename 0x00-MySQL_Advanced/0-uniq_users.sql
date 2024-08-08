-- Creates a `users` table if it does not already exist.
-- The table includes the following columns:
--   - `id`: An integer that serves as the primary key, automatically incremented for each new record. 
--   - `email`: A VARCHAR field that stores the user's email address, which must be unique and cannot be null.
--   - `name`: A VARCHAR field that stores the user's name, which is optional (can be null).

CREATE TABLE IF NOT EXISTS users (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255)
);
