CREATE OR REPLACE DYNAMIC TABLE datamart.fct_start_list
TARGET_LAG = '6 hours'
WAREHOUSE = COMPUTE_WH
AS
SELECT 
    pe.event_id,
    pe.prog_id,
    e.event_title,
    e.event_date,
    p.prog_name,
    f.value:athlete_id::NUMBER AS athlete_id
FROM staging.programs_entries pe
INNER JOIN datamart.dim_event e ON e.event_id = pe.event_id
INNER JOIN datamart.dim_program p ON p.event_id = pe.event_id AND p.prog_id = pe.prog_id,
LATERAL FLATTEN (INPUT => pe.entries) f
;

-- ALTER DYNAMIC TABLE datamart.fct_start_list REFRESH;