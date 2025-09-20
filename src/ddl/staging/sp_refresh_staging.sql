CREATE OR REPLACE PROCEDURE staging.sp_refresh_staging()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    start_ts TIMESTAMP := CURRENT_TIMESTAMP();
    last_ts TIMESTAMP;
BEGIN
    -- Total start
    SYSTEM$LOG('INFO', start_ts || ' - sp_refresh_staging START');

    -- 1) Fetch remote Git repository
    last_ts := CURRENT_TIMESTAMP();
    ALTER GIT REPOSITORY governance.git_repo_stage_world_triathlon FETCH;
    SYSTEM$LOG('INFO', 'Git repo fetched in ' || DATEDIFF('second', last_ts, CURRENT_TIMESTAMP()) || ' seconds');

    -- 2) events.sql
    last_ts := CURRENT_TIMESTAMP();
    EXECUTE IMMEDIATE FROM @governance.git_repo_stage_world_triathlon/branches/main/src/dml/staging/events.sql;
    SYSTEM$LOG('INFO','events.sql executed in ' || DATEDIFF('second', last_ts, CURRENT_TIMESTAMP()) || ' seconds');

    -- 3) programs.sql
    last_ts := CURRENT_TIMESTAMP();
    EXECUTE IMMEDIATE FROM @governance.git_repo_stage_world_triathlon/branches/main/src/dml/staging/programs.sql;
    SYSTEM$LOG('INFO','programs.sql executed in ' || DATEDIFF('second', last_ts, CURRENT_TIMESTAMP()) || ' seconds');

    -- 4) programs_results.sql
    last_ts := CURRENT_TIMESTAMP();
    EXECUTE IMMEDIATE FROM @governance.git_repo_stage_world_triathlon/branches/main/src/dml/staging/programs_results.sql;
    SYSTEM$LOG('INFO','programs_results.sql executed in ' || DATEDIFF('second', last_ts, CURRENT_TIMESTAMP()) || ' seconds');

    -- 5) programs_entries.sql
    last_ts := CURRENT_TIMESTAMP();
    EXECUTE IMMEDIATE FROM @governance.git_repo_stage_world_triathlon/branches/main/src/dml/staging/programs_entries.sql;
    SYSTEM$LOG('INFO','programs_entries.sql executed in ' || DATEDIFF('second', last_ts, CURRENT_TIMESTAMP()) || ' seconds');

    -- 6) ranking.sql
    last_ts := CURRENT_TIMESTAMP();
    EXECUTE IMMEDIATE FROM @governance.git_repo_stage_world_triathlon/branches/main/src/dml/staging/ranking.sql;
    SYSTEM$LOG('INFO','ranking.sql executed in ' || DATEDIFF('second', last_ts, CURRENT_TIMESTAMP()) || ' seconds');

    -- 7) ranking_details.sql
    last_ts := CURRENT_TIMESTAMP();
    EXECUTE IMMEDIATE FROM @governance.git_repo_stage_world_triathlon/branches/main/src/dml/staging/ranking_details.sql;
    SYSTEM$LOG('INFO','ranking_details.sql executed in ' || DATEDIFF('second', last_ts, CURRENT_TIMESTAMP()) || ' seconds');

    -- Total end
    SYSTEM$LOG('INFO', CURRENT_TIMESTAMP() || ' - sp_refresh_staging END');
    RETURN 'Successful staging refresh in ' || DATEDIFF('second', start_ts, CURRENT_TIMESTAMP()) || ' seconds';

EXCEPTION
    WHEN OTHER THEN
        SYSTEM$LOG('ERROR', 'Error encountered: ' || SQLERRM);
        RETURN 'Error encountered: ' || SQLERRM;
END;
$$;
