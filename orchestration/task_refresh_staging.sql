CREATE OR REPLACE TASK orchestration.task_refresh_staging
WAREHOUSE = compute_wh
SCHEDULE = 'USING CRON 0 0 * * 3 UTC'
AS
    CALL staging.sp_refresh_staging();
