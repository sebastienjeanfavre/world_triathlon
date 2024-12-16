INSERT OVERWRITE INTO datamart.fct_results
SELECT 
    p.prog_id,
    p.event_id,
    f.value:athlete_id::NUMBER AS athlete_id,
    p.prog_date_utc AS prog_date,
    f.value:position::VARCHAR(256) AS finish_position,
    f.value:total_time::VARCHAR(256) AS total_time,
    p.prog_distance_category,
    p.prog_distances,
    p.prog_notes,
    pr.headers[0]:name::VARCHAR(256) AS seg1,
    pr.headers[1]:name::VARCHAR(256) AS seg2,
    pr.headers[2]:name::VARCHAR(256) AS seg3,
    pr.headers[3]:name::VARCHAR(256) AS seg4,
    pr.headers[4]:name::VARCHAR(256) AS seg5,
    f.value:splits[0]::VARCHAR(256) AS split1,
    f.value:splits[1]::VARCHAR(256) AS split2,
    f.value:splits[2]::VARCHAR(256) AS split3,
    f.value:splits[3]::VARCHAR(256) AS split4,
    f.value:splits[4]::VARCHAR(256) AS split5,    
FROM staging.programs_results pr
JOIN staging.programs p ON p.prog_id = pr.prog_id,
TABLE(FLATTEN(input => pr.results)) f

-- Tests --
-- uniqueness of (prog_id, athlete_id)
-- ARRAY_SIZE(headers) = 5
-- ARRAY_SIZE(splits) = 5