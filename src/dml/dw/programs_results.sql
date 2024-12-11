SELECT 
    p.prog_id,
    p.event_id,
    f.value:athlete_id::NUMBER AS athlete_id,
    p.prog_date_utc AS prog_date,
    f.value:position::VARCHAR(64) AS finish_position,
    f.value:total_time::VARCHAR(64) AS total_time,
    p.prog_distance_category,
    p.prog_distances,
    p.prog_notes,
    pr.headers[0]:name::VARCHAR AS seg1,
    pr.headers[1]:name::VARCHAR AS seg2,
    pr.headers[2]:name::VARCHAR AS seg3,
    pr.headers[3]:name::VARCHAR AS seg4,
    pr.headers[4]:name::VARCHAR AS seg5,
    f.value:splits[0]::VARCHAR AS split1,
    f.value:splits[1]::VARCHAR AS split2,
    f.value:splits[2]::VARCHAR AS split3,
    f.value:splits[3]::VARCHAR AS split4,
    f.value:splits[4]::VARCHAR AS split5,    
FROM world_triathlon.staging.programs_results pr
JOIN world_triathlon.staging.programs p ON p.prog_id = pr.prog_id,
TABLE(FLATTEN(input => pr.results)) f

-- Tests --
-- uniqueness of (prog_id, athlete_id)
-- ARRAY_SIZE(headers) = 5
-- ARRAY_SIZE(splits) = 5