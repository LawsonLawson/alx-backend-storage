-- SQL script that ranks the countries of origin for metal bands,
-- ordered by the total number of fans (including non-unique fan counts).
-- The query performs the following actions:
--   - Selects each unique country of origin (`origin`) from the `metal_bands` table.
--   - Calculates the total number of fans (`nb_fans`) for each country by summing the `fans` column.
--   - Groups the results by the `origin` to ensure that each country's fan count is aggregated.
--   - Orders the results in descending order by `nb_fans`, so the countries with the highest fan counts appear first.

SELECT DISTINCT origin, SUM(fans) AS nb_fans
FROM metal_bands
GROUP BY origin
ORDER BY nb_fans DESC;
