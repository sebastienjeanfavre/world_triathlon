CREATE OR REPLACE PROCEDURE staging.sp_refresh_staging()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
BEGIN
    
    -- Refresh events, programs and results (not athletes)
    ALTER GIT REPOSITORY public.git_repo_stage_world_triathlon FETCH;
    -- All events are loaded everytime
    EXECUTE IMMEDIATE FROM @public.git_repo_stage_world_triathlon/branches/develop/src/dml/staging/events.sql;
    -- Programs are refreshed if event_date >= addmonth(current_date - 1)
    EXECUTE IMMEDIATE FROM @public.git_repo_stage_world_triathlon/branches/develop/src/dml/staging/programs.sql;
    -- Programs are refreshed if event_date >= addmonth(current_date - 1)
    EXECUTE IMMEDIATE FROM @public.git_repo_stage_world_triathlon/branches/develop/src/dml/staging/programs_results.sql;
    
    RETURN 'Successful refresh :D';
END;
$$;


CALL staging.sp_refresh_staging();