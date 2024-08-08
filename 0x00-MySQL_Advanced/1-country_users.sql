-- Creates a `users` table if it does not already exist.
-- The table includes the following columns:
--   - `id`: An integer that serves as the primary key, automatically incremented for each new record.
--     It cannot be null.
--   - `email`: A VARCHAR field that stores the user's email address, which must be unique and cannot be null.
--   - `name`: A VARCHAR field that stores the user's name, which is optional (can be null).
--   - `country`: An ENUM field that stores the user's country, restricted to one of the following values:
--     'US' (United States), 'CO' (Colombia), or 'TN' (Tunisia). This field is required (cannot be null).

CREATE TABLE IF NOT EXISTS users (
  id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  name VARCHAR(255),
  country ENUM('US', 'CO', 'TN') NOT NULL
);
