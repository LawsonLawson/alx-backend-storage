-- SQL script that creates a stored procedure `ComputeAverageWeightedScoreForUser`
-- This procedure calculates and stores the average weighted score for a specific student.
-- The procedure performs the following actions:
--   - Accepts one input parameter:
--     1. `user_id`: The ID of the student whose average weighted score is to be computed.
--   - Declares two variables:
--     1. `total_weighted_score`: Stores the sum of weighted scores for the student's projects.
--     2. `total_weight`: Stores the sum of the weights of the projects the student has worked on.
--   - Calculates the total weighted score by summing the product of each project's `score` and its `weight`.
--   - Calculates the total weight by summing the `weight` of all projects associated with the student.
--   - If the `total_weight` is zero (meaning the student has no recorded projects or weights),
--     it sets the student's `average_score` to 0.
--   - Otherwise, it computes the average weighted score by dividing `total_weighted_score` by `total_weight`
--     and updates the `users` table with this value.

DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUser;

DELIMITER $$

CREATE PROCEDURE ComputeAverageWeightedScoreForUser (user_id INT)
BEGIN
    DECLARE total_weighted_score INT DEFAULT 0;
    DECLARE total_weight INT DEFAULT 0;

    -- Calculate the total weighted score for the given user_id
    SELECT SUM(corrections.score * projects.weight)
        INTO total_weighted_score
        FROM corrections
        INNER JOIN projects
            ON corrections.project_id = projects.id
        WHERE corrections.user_id = user_id;

    -- Calculate the total weight of the projects for the given user_id
    SELECT SUM(projects.weight)
        INTO total_weight
        FROM corrections
        INNER JOIN projects
            ON corrections.project_id = projects.id
        WHERE corrections.user_id = user_id;

    -- Check if the total weight is zero and update average_score accordingly
    IF total_weight = 0 THEN
        UPDATE users
            SET users.average_score = 0
            WHERE users.id = user_id;
    ELSE
        -- Update the user's average_score with the calculated weighted average
        UPDATE users
            SET users.average_score = total_weighted_score / total_weight
            WHERE users.id = user_id;
    END IF;
END $$
DELIMITER ;
