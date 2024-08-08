-- Creates an index `idx_name_first_score` on the `names` table.
-- This composite index is designed to optimize queries that search
-- based on both the first letter of the `name` column and the `score` column.
-- The index is created as follows:
--   - The index is named `idx_name_first_score`.
--   - It covers both the first character of the `name` column (indicated by `name(1)`)
--     and the `score` column.
--   - This composite index improves the performance of queries that filter or sort
--     by both the initial character of `name` and the `score` value.

CREATE INDEX idx_name_first_score 
ON names (name(1), score);
