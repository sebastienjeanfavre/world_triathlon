CREATE OR REPLACE TASK orchestration.task_refresh_staging
WAREHOUSE = compute_wh
SCHEDULE = 'USING CRON 0 1 * * 2 UTC'
AS
    CALL staging.sp_refresh_staging()
;

-- EXECUTE TASK orchestration.task_refresh_staging;
-- ALTER TASK orchestration.task_refresh_staging RESUME;
-- select max(load_ts) from datamart.dim_program;

-- -- SELECT * FROM TABLE(information_schema.task_history())
-- ORDER BY query_start_time DESC;