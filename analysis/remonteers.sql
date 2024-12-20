-- Athletes gaining places
WITH 
t1 AS (
    SELECT
        athlete_id,
        COUNT(prog_id) AS nb_courses,
        AVG((split1_rank - split123_rank)/nb_finishers) AS avg_places_gained_bike,
        AVG((split123_rank - split12345_rank)/nb_finishers) AS avg_places_gained_run,
        avg_places_gained_bike + avg_places_gained_run AS avg_places_gained
    FROM world_triathlon.datamart.fct_results
    WHERE TRY_TO_NUMBER(finish_position) IS NOT NULL
        AND split1_time_s > 0
        AND split2_time_s > 0
        AND split3_time_s > 0
        AND split4_time_s > 0
        AND split5_time_s > 0
        AND headers[0]:name = 'Swim'
        AND split12345_time_s BETWEEN total_time_s - 60 AND total_time_s + 60
    GROUP BY athlete_id
    )
SELECT
    RANK() OVER (ORDER BY avg_places_gained DESC) AS remontada_rank,
    a.athlete_fullname,
    t1.*
FROM world_triathlon.datamart.dim_athlete a
INNER JOIN t1 ON t1.athlete_id = a.athlete_id
WHERE nb_courses > 4
AND athlete_gender = 'female'
ORDER BY avg_places_gained DESC
;