WITH prog_with_dist AS (
    SELECT 
        fct.*,
        dim.event_title,
        p.prog_name
    FROM datamart.fct_results fct
    INNER JOIN datamart.dim_event_continental_cup dim ON dim.event_id = fct.event_id
    INNER JOIN datamart.dim_program p ON p.prog_id = fct.prog_id
    WHERE fct.prog_distances != '[]'
    AND p.prog_name LIKE ANY ('Elite%', 'U23%')
),
indiv_pace AS (
    SELECT
        -- athlete_full_name,
        -- finish_position,
        event_title,
        prog_name,
        f.value:segment::VARCHAR AS segment,
        TRY_TO_NUMBER(f.value:distance::VARCHAR) AS distance_m,
        TRY_TO_NUMBER(f.value:laps::VARCHAR) AS nb_laps,
        split5_time_s/60 AS split5_time_min,
        1000/60*split5_time_s/distance_m AS run_pace_min_km,
        FLOOR(run_pace_min_km) || ':' || FLOOR(60*(run_pace_min_km-FLOOR(run_pace_min_km))) || ' min/km' AS run_pace
    FROM prog_with_dist t,
    LATERAL FLATTEN(input => prog_distances) f
    WHERE segment = 'Run'
    AND distance_m BETWEEN 4000 AND 6000
    ORDER BY run_pace_min_km
)
SELECT
    prog_name,
    PERCENTILE_CONT(0.1) WITHIN GROUP (ORDER BY run_pace_min_km) AS run_pace_10th_perc,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY run_pace_min_km) AS run_pace_50th_perc,
    PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY run_pace_min_km) AS run_pace_90th_perc
FROM indiv_pace
GROUP BY prog_name;


WITH prog_with_dist AS (
    SELECT 
        fct.*,
        dim.event_title,
        p.prog_name
    FROM datamart.fct_results fct
    INNER JOIN datamart.dim_event_continental_cup dim ON dim.event_id = fct.event_id
    INNER JOIN datamart.dim_program p ON p.prog_id = fct.prog_id
    WHERE fct.prog_distances != '[]'
    AND flag_no_finish IS NULL
    --AND p.prog_name = 'Elite Women'
),
indiv_pace AS (
    SELECT
        athlete_full_name,
        finish_position,
        event_title,
        prog_name,
        f.value:segment::VARCHAR AS segment,
        TRY_TO_NUMBER(f.value:distance::VARCHAR) AS distance_m,
        TRY_TO_NUMBER(f.value:laps::VARCHAR) AS nb_laps,
        split5_time_s/60 AS split5_time_min,
        1000/60*split5_time_s/distance_m AS run_pace_min_km,
        FLOOR(run_pace_min_km) || ':' || FLOOR(60*(run_pace_min_km-FLOOR(run_pace_min_km))) || ' min/km' AS run_pace
    FROM prog_with_dist t,
    LATERAL FLATTEN(input => prog_distances) f
    WHERE segment = 'Run'
    AND distance_m BETWEEN 4000 AND 6000
    AND split5_time_min > 13
    ORDER BY run_pace_min_km
)
SELECT
    athlete_full_name,
    prog_name,
    COUNT(*) AS cnt,
    AVG(run_pace_min_km) AS avg_run_pace_min_km,
    FLOOR(avg_run_pace_min_km) || ':' || FLOOR(60*(avg_run_pace_min_km-FLOOR(avg_run_pace_min_km))) || ' min/km' AS run_pace
FROM indiv_pace
WHERE prog_name = 'Elite Women'
GROUP BY ALL
ORDER BY athlete_full_name;