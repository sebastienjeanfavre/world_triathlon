CREATE OR REPLACE PROCEDURE staging.sp_refresh_datamart()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
BEGIN
    
    -- Refresh events, programs and results (not athletes)
    ALTER GIT REPOSITORY public.git_repo_stage_world_triathlon FETCH;
    -- All events are loaded everytime
    EXECUTE IMMEDIATE FROM @public.git_repo_stage_world_triathlon/branches/main/src/dml/datamart/dim_event.sql;
    EXECUTE IMMEDIATE FROM @public.git_repo_stage_world_triathlon/branches/main/src/dml/datamart/dim_program.sql;
    EXECUTE IMMEDIATE FROM @public.git_repo_stage_world_triathlon/branches/main/src/dml/datamart/fct_results.sql;
    
    RETURN 'Successful refresh :D';
END;
$$;
