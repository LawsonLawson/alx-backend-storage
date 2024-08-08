-- SQL script that creates a view `need_meeting`
-- This view lists all students who meet the following criteria:
--   - Have a score strictly below 80.
--   - Either have no recorded `last_meeting` date or their `last_meeting` was more than 1 month ago.
-- The view is created as follows:
--   - The view is named `need_meeting`.
--   - It selects the `name` of students from the `students` table.
--   - The view includes students who either:
--     1. Have a `score` less than 80 and no recorded `last_meeting` (`last_meeting` is NULL).
--     2. Have a `score` less than 80 and a `last_meeting` date that is more than 1 month old from the current date.

DROP VIEW IF EXISTS need_meeting;

CREATE VIEW need_meeting
AS
SELECT name
FROM students
WHERE (score < 80 AND last_meeting IS NULL)
   OR (score < 80 AND last_meeting < DATE_SUB(NOW(), INTERVAL 1 MONTH));
