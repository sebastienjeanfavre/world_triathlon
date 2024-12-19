-- SELECT GET_DDL('table', 'datamart.fct_results');
-- CREATE OR REPLACE TABLE datamart.fct_results AS
INSERT OVERWRITE INTO datamart.fct_results
SELECT 
    p.prog_id,
    p.event_id,
    f.value:athlete_id::NUMBER AS athlete_id,
    p.prog_date_utc AS prog_date,
    TRY_TO_NUMBER(f.value:position::VARCHAR(256)) AS finish_position,
    IFF(finish_position IS NULL, f.value:position, NULL)::VARCHAR(256) AS flag_no_finish,
    SECOND(TRY_TO_TIME(f.value:total_time::VARCHAR)) + MINUTE(TRY_TO_TIME(f.value:total_time::VARCHAR))*60 + HOUR(TRY_TO_TIME(f.value:total_time::VARCHAR))*3600 AS total_time_s,
    p.prog_distance_category,
    p.prog_distances,
    p.prog_notes,
    pr.headers AS headers,
    SECOND(TRY_TO_TIME(f.value:splits[0]::VARCHAR)) + MINUTE(TRY_TO_TIME(f.value:splits[0]::VARCHAR))*60 + HOUR(TRY_TO_TIME(f.value:splits[0]::VARCHAR))*3600 AS split1_time_s,
    SECOND(TRY_TO_TIME(f.value:splits[1]::VARCHAR)) + MINUTE(TRY_TO_TIME(f.value:splits[1]::VARCHAR))*60 + HOUR(TRY_TO_TIME(f.value:splits[1]::VARCHAR))*3600 AS split2_time_s,
    SECOND(TRY_TO_TIME(f.value:splits[2]::VARCHAR)) + MINUTE(TRY_TO_TIME(f.value:splits[2]::VARCHAR))*60 + HOUR(TRY_TO_TIME(f.value:splits[2]::VARCHAR))*3600 AS split3_time_s,
    SECOND(TRY_TO_TIME(f.value:splits[3]::VARCHAR)) + MINUTE(TRY_TO_TIME(f.value:splits[3]::VARCHAR))*60 + HOUR(TRY_TO_TIME(f.value:splits[3]::VARCHAR))*3600 AS split4_time_s,
    SECOND(TRY_TO_TIME(f.value:splits[4]::VARCHAR)) + MINUTE(TRY_TO_TIME(f.value:splits[4]::VARCHAR))*60 + HOUR(TRY_TO_TIME(f.value:splits[4]::VARCHAR))*3600 AS split5_time_s,
    ROW_NUMBER() OVER (PARTITION BY p.prog_id ORDER BY split1_time_s) AS split1_rank,
    ROW_NUMBER() OVER (PARTITION BY p.prog_id ORDER BY split2_time_s) AS split2_rank,
    ROW_NUMBER() OVER (PARTITION BY p.prog_id ORDER BY split3_time_s) AS split3_rank,
    ROW_NUMBER() OVER (PARTITION BY p.prog_id ORDER BY split4_time_s) AS split4_rank,
    ROW_NUMBER() OVER (PARTITION BY p.prog_id ORDER BY split5_time_s) AS split5_rank,
    split1_time_s + split2_time_s AS split12_time_s,
    split1_time_s + split2_time_s + split3_time_s AS split123_time_s,
    split1_time_s + split2_time_s + split3_time_s + split4_time_s AS split1234_time_s,
    split1_time_s + split2_time_s + split3_time_s + split4_time_s + split5_time_s AS split12345_time_s,
    ROW_NUMBER() OVER (PARTITION BY p.prog_id ORDER BY split12_time_s) AS split12_rank,
    ROW_NUMBER() OVER (PARTITION BY p.prog_id ORDER BY split123_time_s) AS split123_rank,
    ROW_NUMBER() OVER (PARTITION BY p.prog_id ORDER BY split1234_time_s) AS split1234_rank,
    ROW_NUMBER() OVER (PARTITION BY p.prog_id ORDER BY split12345_time_s) AS split12345_rank,
    COUNT(athlete_id) OVER (PARTITION BY pr.prog_id) AS nb_finishers
FROM staging.programs_results pr
JOIN staging.programs p ON p.prog_id = pr.prog_id,
TABLE(FLATTEN(input => pr.results)) f

-- Tests --
-- uniqueness of (prog_id, athlete_id)
-- ARRAY_SIZE(headers) = 5
-- ARRAY_SIZE(splits) = 5