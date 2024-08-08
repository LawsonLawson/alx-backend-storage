-- SQL script that lists all metal bands with "Glam rock" as their main style,
-- ranked by their longevity (lifespan).
-- The query performs the following actions:
--   - Selects each unique `band_name` from the `metal_bands` table.
--   - Calculates the band's lifespan (`lifespan`) by subtracting the year they
--     were formed (`formed`) from the year they split (`split`).
--   - If the band has not split, the year 2022 is used as the default value
--     for `split` using the IFNULL function.
--   - Filters the bands to include only those whose style includes "Glam rock".
--   - Orders the results by `lifespan` in descending order, so the bands with
--     the longest lifespan appear first.

SELECT DISTINCT `band_name`,
                IFNULL(`split`, 2022) - `formed` AS `lifespan`
  FROM `metal_bands`
  WHERE FIND_IN_SET('Glam rock', `style`)
  ORDER BY `lifespan` DESC;
