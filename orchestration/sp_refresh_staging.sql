CREATE OR REPLACE PROCEDURE staging.sp_refresh_staging()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
BEGIN
    -- Refresh events, programs and results (not athletes)
    ALTER GIT REPOSITORY public.git_repo_stage_world_triathlon FETCH;
    EXECUTE IMMEDIATE FROM @public.git_repo_stage_world_triathlon/branches/main/src/dml/staging/events.sql;
    EXECUTE IMMEDIATE FROM @public.git_repo_stage_world_triathlon/branches/main/src/dml/staging/programs.sql;
    EXECUTE IMMEDIATE FROM @public.git_repo_stage_world_triathlon/branches/main/src/dml/staging/programs_results.sql;
    
    RETURN 'Successful refresh :D';
END;
$$;


CALL staging.sp_refresh_staging();