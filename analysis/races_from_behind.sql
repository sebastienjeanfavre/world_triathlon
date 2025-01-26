-- Optimal events to race from the back
WITH next_season_races AS (
    SELECT
        SPLIT_PART(e.event_title, ' ', -1) AS race_place,
    FROM datamart.dim_event e
    WHERE YEAR(e.event_date) = 2025
)
SELECT
    SPLIT_PART(e.event_title, ' ', -1) AS race_place,
    -- SPLIT_PART(e.event_title, ' ', 2) AS race_level,
    COUNT(DISTINCT event_title) AS nb_races,
    AVG(split12_rank - split123_rank) AS avg_places_gained_bike,
FROM datamart.fct_results fct
INNER JOIN world_triathlon.datamart.dim_event e ON e.event_id = fct.event_id
INNER JOIN next_season_races n_e ON n_e.race_place = SPLIT_PART(e.event_title, ' ', -1)
WHERE fct.split1_rank > 20
    -- AND e.event_region_name = 'Europe'
    AND headers[0]:name = 'Swim'
    AND fct.split12345_time_s BETWEEN fct.total_time_s - 60 AND fct.total_time_s + 60 -- total_time = sum(splits) +- 1 minute
GROUP BY SPLIT_PART(e.event_title, ' ', -1)--, race_level
HAVING AVG(total_time_s) > 45*60
ORDER BY avg_places_gained_bike DESC
;