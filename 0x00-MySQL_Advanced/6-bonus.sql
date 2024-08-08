-- Creates a stored procedure `AddBonus`
-- This procedure adds a new project (if it doesn't already exist)
-- and then records a correction (score) for a specific student on that project.
-- The procedure performs the following actions:
--   - Accepts three input parameters:
--     1. `user_id`: The ID of the student.
--     2. `project_name`: The name of the project.
--     3. `score`: The score or correction to be recorded for the student.
--   - First, it checks if the project name already exists in the `projects` table.
--   - If the project does not exist, it inserts the `project_name` into the `projects` table.
--   - Then, it inserts a new record into the `corrections` table, associating the student (`user_id`)
--     with the project's ID and recording the `score`.

DELIMITER |
CREATE PROCEDURE AddBonus (
    IN user_id INT,
    IN project_name VARCHAR(255),
    IN score FLOAT
)
BEGIN
    -- Insert the project name if it does not already exist in the projects table
    INSERT INTO projects (name)
    SELECT project_name
    FROM DUAL
    WHERE NOT EXISTS (
        SELECT * FROM projects WHERE name = project_name
    );

    -- Insert the correction record for the user
    INSERT INTO corrections (user_id, project_id, score)
    VALUES (
        user_id,
        (SELECT id FROM projects WHERE name = project_name),
        score
    );
END;
|
