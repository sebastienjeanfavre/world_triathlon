select * 
from fct_results
where athlete_id = 104222;


SELECT 
    PERCENTILE_CONT(0.1) WITHIN GROUP (ORDER BY split1_time_s) AS swim_10p,
    MEDIAN(split1_time_s) AS swim_50p,
    PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY split1_time_s) AS swim_90p,
    
    PERCENTILE_CONT(0.1) WITHIN GROUP (ORDER BY split3_time_s) AS bike_10p,
    MEDIAN(split3_time_s) AS bike_50p,
    PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY split3_time_s) AS bike_90p,
    
    PERCENTILE_CONT(0.1) WITHIN GROUP (ORDER BY split5_time_s) AS run_10p,
    MEDIAN(split5_time_s) AS run_50,
    PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY split5_time_s) AS run_90p,
    
FROM datamart.fct_results
WHERE prog_id = 635200;


SELECT
    split1_time_s,
    finish_position,
FROM datamart.fct_results
WHERE prog_id = 635200;

SELECT
    split3_time_s,
    finish_position,
FROM datamart.fct_results
WHERE prog_id = 635200;

SELECT
    split5_time_s,
    split12345_rank,
    finish_position,
FROM datamart.fct_results
WHERE prog_id = 635200;

