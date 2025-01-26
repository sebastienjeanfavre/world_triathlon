CREATE OR REPLACE TASK orchestration.task_refresh_datamart
WAREHOUSE = compute_wh
AFTER orchestration.task_refresh_staging
AS
    CALL staging.sp_refresh_datamart();

-- ALTER TASK orchestration.task_refresh_datamart RESUME;