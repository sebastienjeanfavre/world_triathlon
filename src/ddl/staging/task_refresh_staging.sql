ALTER TASK staging.task_refresh_staging SUSPEND;

CREATE OR ALTER TASK staging.task_refresh_staging
WAREHOUSE = SWISS_TRIATHLON_WH
SCHEDULE = 'USING CRON 0 1 * * * UTC'
AS
    CALL staging.sp_refresh_staging()
;

ALTER TASK staging.task_refresh_staging RESUME;
