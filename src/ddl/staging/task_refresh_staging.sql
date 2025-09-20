ALTER TASK staging.task_refresh_staging SUSPEND;

CREATE OR ALTER TASK staging.task_refresh_staging
WAREHOUSE = COMPUTE_WH
SCHEDULE = 'USING CRON 0 3 * * * UTC'
AS
    CALL staging.sp_refresh_staging()
;

ALTER TASK staging.task_refresh_staging RESUME;
