-- Creates an index `idx_name_first` on the `names` table.
-- This index is designed to improve the performance of queries that search
-- based on the first character of the `name` column.
-- The index is created as follows:
--   - The index is named `idx_name_first`.
--   - It is applied to the `name` column of the `names` table.
--   - The index uses only the first character of the `name` column
--     (indicated by `name(1)`), which can optimize searches and comparisons
--     involving the initial character of names.

CREATE INDEX idx_name_first 
ON names (name(1));
