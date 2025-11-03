CREATE OR REPLACE DYNAMIC TABLE datamart.fct_results
TARGET_LAG = '6 hours'
WAREHOUSE = SWISS_TRIATHLON_WH
AS
WITH T1 AS (
    SELECT
        p.prog_id,
        p.event_id,
        f.value:athlete_id::NUMBER AS athlete_id,
        f.value:athlete_full_name::VARCHAR AS athlete_full_name,
        p.prog_date_utc AS prog_date,
        TRY_TO_NUMBER(f.value:position::VARCHAR) AS finish_position,
        IFF(finish_position IS NULL, f.value:position, NULL)::VARCHAR AS flag_no_finish,
        p.prog_distance_category,
        p.prog_distances,
        p.prog_notes,
        pr.headers AS headers,

        SECOND(TRY_TO_TIME(f.value:splits[0]::VARCHAR))
            + MINUTE(TRY_TO_TIME(f.value:splits[0]::VARCHAR))*60
            + HOUR(TRY_TO_TIME(f.value:splits[0]::VARCHAR))*3600 AS split1_time_s,
        SECOND(TRY_TO_TIME(f.value:splits[1]::VARCHAR))
            + MINUTE(TRY_TO_TIME(f.value:splits[1]::VARCHAR))*60
            + HOUR(TRY_TO_TIME(f.value:splits[1]::VARCHAR))*3600 AS split2_time_s,
        SECOND(TRY_TO_TIME(f.value:splits[2]::VARCHAR))
            + MINUTE(TRY_TO_TIME(f.value:splits[2]::VARCHAR))*60
            + HOUR(TRY_TO_TIME(f.value:splits[2]::VARCHAR))*3600 AS split3_time_s,
        SECOND(TRY_TO_TIME(f.value:splits[3]::VARCHAR))
            + MINUTE(TRY_TO_TIME(f.value:splits[3]::VARCHAR))*60
            + HOUR(TRY_TO_TIME(f.value:splits[3]::VARCHAR))*3600 AS split4_time_s,
        SECOND(TRY_TO_TIME(f.value:splits[4]::VARCHAR))
            + MINUTE(TRY_TO_TIME(f.value:splits[4]::VARCHAR))*60
            + HOUR(TRY_TO_TIME(f.value:splits[4]::VARCHAR))*3600 AS split5_time_s,
        SECOND(TRY_TO_TIME(f.value:total_time::VARCHAR))
            + MINUTE(TRY_TO_TIME(f.value:total_time::VARCHAR))*60
            + HOUR(TRY_TO_TIME(f.value:total_time::VARCHAR))*3600 AS total_time_s,

        split1_time_s + split2_time_s AS split12_time_s,
        split1_time_s + split2_time_s + split3_time_s AS split123_time_s,
        split1_time_s + split2_time_s + split3_time_s + split4_time_s AS split1234_time_s,
        split1_time_s + split2_time_s + split3_time_s + split4_time_s + split5_time_s AS split12345_time_s,

        ROW_NUMBER() OVER (PARTITION BY p.prog_id ORDER BY split1_time_s) AS split1_rank,
        ROW_NUMBER() OVER (PARTITION BY p.prog_id ORDER BY split2_time_s) AS split2_rank,
        ROW_NUMBER() OVER (PARTITION BY p.prog_id ORDER BY split3_time_s) AS split3_rank,
        ROW_NUMBER() OVER (PARTITION BY p.prog_id ORDER BY split4_time_s) AS split4_rank,
        ROW_NUMBER() OVER (PARTITION BY p.prog_id ORDER BY split5_time_s) AS split5_rank,

        ROW_NUMBER() OVER (PARTITION BY p.prog_id ORDER BY split12_time_s) AS split12_rank,
        ROW_NUMBER() OVER (PARTITION BY p.prog_id ORDER BY split123_time_s) AS split123_rank,
        ROW_NUMBER() OVER (PARTITION BY p.prog_id ORDER BY split1234_time_s) AS split1234_rank,
        ROW_NUMBER() OVER (PARTITION BY p.prog_id ORDER BY split12345_time_s) AS split12345_rank,

        COUNT(athlete_id) OVER (PARTITION BY pr.prog_id) AS nb_finishers,
        pr.load_ts
    FROM staging.programs_results pr
    JOIN staging.programs p ON p.prog_id = pr.prog_id,
    TABLE(FLATTEN(input => pr.results)) f
    WHERE headers[0]:name = 'Swim'
    AND headers[2]:name = 'Bike'
    AND headers[4]:name = 'Run'
    AND split1_time_s > 0
    AND split2_time_s > 0
    AND split3_time_s > 0
    AND split4_time_s > 0
    AND split5_time_s > 0
),
T2 AS (
    SELECT
        prog_id,
        MIN(split1_time_s) AS leader_time_after_swim_s,
        MIN(split12_time_s) AS leader_time_after_t1_s,
        MIN(split123_time_s) AS leader_time_after_bike_s,
        MIN(split1234_time_s) AS leader_time_after_t2_s,
        MIN(split12345_time_s) AS leader_time_after_run_s
    FROM T1
    WHERE flag_no_finish IS NULL
    GROUP BY prog_id
)
SELECT
    T1.*,
    T2.* EXCLUDE(prog_id),
    split1_time_s - leader_time_after_swim_s AS time_to_leader_after_swim_s,
    split12_time_s - leader_time_after_t1_s AS time_to_leader_after_t1_s,
    split123_time_s - leader_time_after_bike_s AS time_to_leader_after_bike_s,
    split1234_time_s - leader_time_after_t2_s AS time_to_leader_after_t2_s,
    split12345_time_s - leader_time_after_run_s AS time_to_leader_after_run_s
FROM T1
LEFT JOIN T2 ON T1.prog_id = T2.prog_id
;

-- ALTER DYNAMIC TABLE datamart.fct_results REFRESH;