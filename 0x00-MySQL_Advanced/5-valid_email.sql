-- Task 5: Email validation trigger
-- This SQL script creates a trigger that resets the `valid_email` attribute
-- in the `users` table whenever the email address is changed.
-- The trigger performs the following actions:
--   - It is triggered before an update is made to a row in the `users` table.
--   - For each updated row, the trigger checks if the new email (`NEW.email`)
--     is different from the old email (`OLD.email`).
--   - If the email has been changed, the trigger sets the `valid_email` attribute
--     to 0 (indicating that the email needs to be revalidated).
--   - If the email has not changed, no action is taken and the `valid_email`
--     attribute remains unchanged.

DELIMITER |
CREATE TRIGGER email_bool 
BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    IF NEW.email <> OLD.email THEN
        SET NEW.valid_email = 0;
    END IF;
END;
|
