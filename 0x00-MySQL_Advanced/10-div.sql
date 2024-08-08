-- SQL script that creates a function `SafeDiv`
-- This function performs division while handling the case where 
-- the divisor might be zero. It returns the result of dividing 
-- the first number by the second number or returns 0 if the 
-- second number is zero.
-- The function operates as follows:
--   - It accepts two integer input parameters:
--     1. `a`: The numerator (the number to be divided).
--     2. `b`: The denominator (the number by which to divide).
--   - It returns a floating-point number.
--   - If the divisor (`b`) is zero, the function sets the result to 0.
--   - Otherwise, it calculates the division of `a` by `b` and sets the result accordingly.
--   - Finally, it returns the computed result.

DELIMITER |
DROP FUNCTION IF EXISTS SafeDiv;

CREATE FUNCTION SafeDiv (a INT, b INT)
RETURNS FLOAT
BEGIN
    DECLARE result FLOAT;

    -- Check if the denominator is zero
    IF b = 0 THEN
        SET result = 0;
    ELSE
        -- Perform division if the denominator is not zero
        SET result = a / b;
    END IF;

    -- Return the result of the division or 0
    RETURN result;
END;
|
DELIMITER ;
