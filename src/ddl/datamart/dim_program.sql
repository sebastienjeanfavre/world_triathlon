CREATE OR REPLACE DYNAMIC TABLE datamart.dim_program
TARGET_LAG = '6 hours'
WAREHOUSE = COMPUTE_WH
AS
WITH swim AS (
    SELECT
        prog_id,
        d.value:distance::VARCHAR(256) AS swim_dist,
        d.value:laps::VARCHAR(256) AS swim_laps
    FROM staging.programs,
    LATERAL FLATTEN (input => prog_distances) d
    WHERE REGEXP_LIKE(d.value:segment::VARCHAR(256), '.*swim.*', 'i')
    QUALIFY COUNT(*) OVER (PARTITION BY prog_id) = 1
),
bike AS (
    SELECT
        prog_id,
        d.value:distance::VARCHAR(256) AS bike_dist,
        d.value:laps::VARCHAR(256) AS bike_laps
    FROM staging.programs,
    LATERAL FLATTEN (input => prog_distances) d
    WHERE REGEXP_LIKE(d.value:segment::VARCHAR(256), '.*bike.*', 'i')
    QUALIFY COUNT(*) OVER (PARTITION BY prog_id) = 1
),
run AS (
    SELECT
        prog_id,
        d.value:distance::VARCHAR(256) AS run_dist,
        d.value:laps::VARCHAR(256) AS run_laps
    FROM staging.programs,
    LATERAL FLATTEN (input => prog_distances) d
    WHERE REGEXP_LIKE(d.value:segment::VARCHAR(256), '.*run.*', 'i')
    QUALIFY COUNT(*) OVER (PARTITION BY prog_id) = 1
)
SELECT DISTINCT
    p.prog_id,
    event_id,
    prog_name,
    prog_gender,
    prog_max_age,
    prog_min_age,
    prog_notes,
    prog_date_utc,
    prog_time_utc,
    prog_timezone_offset,
    prog_distance_category,
    prog_distances,
    s.swim_dist,
    s.swim_laps,
    b.bike_dist,
    b.bike_laps,
    r.run_dist,
    r.run_laps,
    is_race,
    is_results,
    is_live_timing_enabled,
    is_team,
    load_ts
FROM staging.programs p
LEFT JOIN swim s ON s.prog_id = p.prog_id
LEFT JOIN bike b ON b.prog_id = p.prog_id
LEFT JOIN run r ON r.prog_id = p.prog_id
;

-- ALTER DYNAMIC TABLE datamart.dim_program REFRESH;