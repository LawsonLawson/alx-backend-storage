-- Creates a stored procedure `ComputeAverageScoreForUser`
-- This procedure calculates the average score for a specific student and
-- stores it in the `users` table.
-- The procedure performs the following actions:
--   - Accepts one input parameter:
--     1. `user_id`: The ID of the student whose average score is to be computed.
--   - Declares a variable `avg_score` to store the computed average score.
--   - Calculates the average score by selecting the average of the `score`
--     from the `corrections` table where the `user_id` matches the input parameter.
--   - Updates the `average_score` field in the `users` table for the student with the calculated average score.

DROP PROCEDURE IF EXISTS ComputeAverageScoreForUser;

DELIMITER $$

CREATE PROCEDURE ComputeAverageScoreForUser(
    IN user_id INT
)
BEGIN
    DECLARE avg_score FLOAT;

    -- Calculate the average score for the given user_id
    SET avg_score = (
        SELECT AVG(score)
        FROM corrections AS C
        WHERE C.user_id = user_id
    );

    -- Update the average_score in the users table for the given user_id
    UPDATE users 
    SET average_score = avg_score
    WHERE id = user_id;
END
$$

DELIMITER ;
