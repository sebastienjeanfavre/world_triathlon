-- ALTER TASK orchestration.task_refresh_datamart SUSPEND;
CREATE OR ALTER TASK orchestration.task_refresh_datamart
WAREHOUSE = compute_wh
AFTER orchestration.task_refresh_staging
AS
    CALL datamart.sp_refresh_datamart()
;

-- ALTER TASK orchestration.task_refresh_datamart RESUME;