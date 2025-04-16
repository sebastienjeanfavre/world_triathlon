CREATE OR REPLACE PROCEDURE staging.sp_refresh_staging()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
BEGIN
    SYSTEM$LOG('INFO', 'Fetching remote repo');
    ALTER GIT REPOSITORY orchestration.git_repo_stage_world_triathlon FETCH;
    -- All events are loaded everytime
    SYSTEM$LOG('INFO', 'Executing src/dml/staging/events.sql');
    EXECUTE IMMEDIATE FROM @orchestration.git_repo_stage_world_triathlon/branches/main/src/dml/staging/events.sql;
    -- Programs are refreshed if event_date >= addmonth(current_date - 1)
    SYSTEM$LOG('INFO', 'Executing src/dml/staging/programs.sql');
    EXECUTE IMMEDIATE FROM @orchestration.git_repo_stage_world_triathlon/branches/main/src/dml/staging/programs.sql;
    -- Programs are refreshed if event_date >= addmonth(current_date - 1)
    SYSTEM$LOG('INFO', 'Executing src/dml/staging/programs_results.sql');
    EXECUTE IMMEDIATE FROM @orchestration.git_repo_stage_world_triathlon/branches/main/src/dml/staging/programs_results.sql;
    -- Get start lists for future events
    SYSTEM$LOG('INFO', 'Executing src/dml/staging/programs_entries.sql');
    EXECUTE IMMEDIATE FROM @orchestration.git_repo_stage_world_triathlon/branches/main/src/dml/staging/programs_entries.sql;
    -- Refresh rankings
    SYSTEM$LOG('INFO', 'Executing src/dml/staging/ranking.sql');
    EXECUTE IMMEDIATE FROM @orchestration.git_repo_stage_world_triathlon/branches/main/src/dml/staging/ranking.sql;
    -- Refresh ranking details
    SYSTEM$LOG('INFO', 'Executing src/dml/staging/ranking_details.sql');
    EXECUTE IMMEDIATE FROM @orchestration.git_repo_stage_world_triathlon/branches/main/src/dml/staging/ranking_details.sql;
    
    RETURN 'Successful refresh at ' || CURRENT_TIMESTAMP();

EXCEPTION
    WHEN OTHER THEN
        -- Log any errors encountered during execution
        SYSTEM$LOG('ERROR', 'Error encountered: ' || SQLERRM);
        RETURN 'Error encountered: ' || SQLERRM;
END;
$$;
