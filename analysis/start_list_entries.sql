SELECT 
    pe.event_id,
    pe.prog_id,
    e.event_title,
    e.event_date,
    p.prog_name
FROM staging.programs_entries pe
INNER JOIN datamart.dim_event e ON e.event_id = pe.event_id
INNER JOIN datamart.dim_program p ON p.event_id = pe.event_id AND p.prog_id = pe.prog_id;

WITH entries AS (
    SELECT 
        pe.event_id,
        pe.prog_id,
        f.value:athlete_id::NUMBER AS athlete_id
    FROM staging.programs_entries pe,
    LATERAL FLATTEN (INPUT => pe.entries) f
),
race_of_interest AS (
    SELECT
        entries.*,
        a.athlete_fullname,
        e.event_title,
        e.event_region_name,
        e.event_country,
        p.prog_name,
        p.prog_date_utc
    FROM entries
    LEFT JOIN datamart.dim_event e ON e.event_id = entries.event_id
    LEFT JOIN datamart.dim_athlete a ON a.athlete_id = entries.athlete_id
    LEFT JOIN datamart.dim_program p ON p.prog_id = entries.prog_id
    WHERE entries.event_id = 194255
    AND entries.prog_id = 673838
    AND a.athlete_yob < 2007
)

SELECT
    a.athlete_id,
    a.athlete_fullname,
    a.athlete_country_name,
    a.athlete_yob,
    YEAR(PROG_DATE)::VARCHAR AS YR,
    AVG(SPLIT1_RANK/NB_FINISHERS) AS SWIM_TIER,
    AVG(SPLIT3_RANK/NB_FINISHERS) AS BIKE_TIER,
    AVG(SPLIT5_RANK/NB_FINISHERS) AS RUN_TIER,
    MIN(FINISH_POSITION) AS BEST_RESULT,
    MAX(FINISH_POSITION) AS WORST_RESULT,
    COUNT(PROG_DATE) AS NB_RACES,
    OBJECT_AGG(cc.event_title, r.finish_position)
FROM DATAMART.FCT_RESULTS R
INNER JOIN datamart.dim_event_continental_cup cc ON r.event_id = cc.event_id
AND cc.event_region_name = 'Europe'
INNER JOIN DATAMART.DIM_ATHLETE A ON A.ATHLETE_ID = R.ATHLETE_ID
INNER JOIN race_of_interest roi ON roi.athlete_id = a.athlete_id
WHERE YR = 2024
GROUP BY ALL
ORDER BY run_tier ASC
;