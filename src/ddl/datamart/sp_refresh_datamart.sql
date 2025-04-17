CREATE OR REPLACE PROCEDURE datamart.sp_refresh_datamart()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    start_ts TIMESTAMP := CURRENT_TIMESTAMP();
    last_ts TIMESTAMP;
BEGIN
    SYSTEM$LOG('INFO', start_ts || ' - sp_refresh_datamart START');

    -- Fetch Git repo
    last_ts := CURRENT_TIMESTAMP();
    ALTER GIT REPOSITORY orchestration.git_repo_stage_world_triathlon FETCH;
    SYSTEM$LOG('INFO', 'Git repo fetched in ' || DATEDIFF('second', last_ts, CURRENT_TIMESTAMP()) || ' seconds');

    -- dim_event.sql
    last_ts := CURRENT_TIMESTAMP();
    EXECUTE IMMEDIATE FROM @orchestration.git_repo_stage_world_triathlon/branches/main/src/dml/datamart/dim_event.sql;
    SYSTEM$LOG('INFO', 'dim_event.sql executed in ' || DATEDIFF('second', last_ts, CURRENT_TIMESTAMP()) || ' seconds');

    -- dim_program.sql
    last_ts := CURRENT_TIMESTAMP();
    EXECUTE IMMEDIATE FROM @orchestration.git_repo_stage_world_triathlon/branches/main/src/dml/datamart/dim_program.sql;
    SYSTEM$LOG('INFO', 'dim_program.sql executed in ' || DATEDIFF('second', last_ts, CURRENT_TIMESTAMP()) || ' seconds');

    -- fct_results.sql
    last_ts := CURRENT_TIMESTAMP();
    EXECUTE IMMEDIATE FROM @orchestration.git_repo_stage_world_triathlon/branches/main/src/dml/datamart/fct_results.sql;
    SYSTEM$LOG('INFO', 'fct_results.sql executed in ' || DATEDIFF('second', last_ts, CURRENT_TIMESTAMP()) || ' seconds');

    -- fct_ranking.sql
    last_ts := CURRENT_TIMESTAMP();
    EXECUTE IMMEDIATE FROM @orchestration.git_repo_stage_world_triathlon/branches/main/src/dml/datamart/fct_ranking.sql;
    SYSTEM$LOG('INFO', 'fct_ranking.sql executed in ' || DATEDIFF('second', last_ts, CURRENT_TIMESTAMP()) || ' seconds');

    -- Procedure completed
    SYSTEM$LOG('INFO', CURRENT_TIMESTAMP() || ' - sp_refresh_datamart END');
    RETURN 'Successful datamart refresh in ' || DATEDIFF('second', start_ts, CURRENT_TIMESTAMP()) || ' seconds';

EXCEPTION
    WHEN OTHER THEN
        SYSTEM$LOG('ERROR', 'Error encountered: ' || SQLERRM);
        RETURN 'Error encountered: ' || SQLERRM;
END;
$$;
