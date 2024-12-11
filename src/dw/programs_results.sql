CREATE OR REPLACE TABLE wt.dw.results AS
SELECT 
    p.prog_id,
    p.event_id,
    p.prog_distance_category,
    p.prog_distances,
    p.prog_date_utc,
    p.prog_notes,
    f.value:athlete_id::NUMBER(16) AS athlete_id,
    f.value:position::VARCHAR(64) AS finish_position,
    f.value:total_time::VARCHAR AS total_time,
    pr.headers,
    f.value:splits::VARIANT AS splits,
    CASE
        WHEN ARRAY_SIZE(pr.headers) = 5
            AND pr.headers[0]:name = 'Swim'
            AND pr.headers[1]:name = 'T1'
            AND pr.headers[2]:name = 'Bike'
            AND pr.headers[3]:name = 'T2'
            AND pr.headers[4]:name = 'Run'
            THEN 'Triathlon'
        WHEN ARRAY_SIZE(pr.headers) = 5
            AND pr.headers[0]:name = 'Run'
            AND pr.headers[1]:name = 'T1'
            AND pr.headers[2]:name = 'Bike'
            AND pr.headers[3]:name = 'T2'
            AND pr.headers[4]:name = 'Run'
            THEN 'Duathlon'
        ELSE 'Other'
    END AS race_format,
FROM world_triathlon.staging.programs_results pr
INNER JOIN world_triathlon.staging.programs p ON p.prog_id = pr.prog_id,
TABLE(FLATTEN(input => pr.results)) f
ORDER BY race_format
;