-- SQL script that creates a stored procedure `ComputeAverageWeightedScoreForUsers`
-- This procedure calculates and stores the average weighted score for all students in the `users` table.
-- The procedure operates as follows:
--   - No input parameters are required.
--   - Temporarily adds two columns to the `users` table:
--     1. `total_weighted_score`: Stores the sum of weighted scores for each student's projects.
--     2. `total_weight`: Stores the sum of the weights of the projects associated with each student.
--   - For each student, the procedure updates the `total_weighted_score` column with the sum of their
--     project scores multiplied by the corresponding project weights.
--   - It then updates the `total_weight` column with the sum of the weights of the projects for each student.
--   - The procedure calculates the average weighted score for each student and updates the `average_score` column.
--     - If a student's `total_weight` is zero (indicating no recorded projects or weights),
--       their `average_score` is set to 0.
--     - Otherwise, their `average_score` is calculated by dividing `total_weighted_score` by `total_weight`.
--   - Finally, the procedure removes the temporary `total_weighted_score` and `total_weight` columns 
--     from the `users` table.

DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUsers;

DELIMITER $$

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers ()
BEGIN
    -- Add temporary columns to store total weighted score and total weight
    ALTER TABLE users ADD total_weighted_score INT NOT NULL;
    ALTER TABLE users ADD total_weight INT NOT NULL;

    -- Update the total weighted score for each user
    UPDATE users
        SET total_weighted_score = (
            SELECT SUM(corrections.score * projects.weight)
            FROM corrections
            INNER JOIN projects
                ON corrections.project_id = projects.id
            WHERE corrections.user_id = users.id
        );

    -- Update the total weight for each user
    UPDATE users
        SET total_weight = (
            SELECT SUM(projects.weight)
            FROM corrections
            INNER JOIN projects
                ON corrections.project_id = projects.id
            WHERE corrections.user_id = users.id
        );

    -- Calculate and update the average score for each user
    UPDATE users
        SET users.average_score = IF(users.total_weight = 0, 0, users.total_weighted_score / users.total_weight);

    -- Remove the temporary columns
    ALTER TABLE users
        DROP COLUMN total_weighted_score;
    ALTER TABLE users
        DROP COLUMN total_weight;
END $$
DELIMITER ;
