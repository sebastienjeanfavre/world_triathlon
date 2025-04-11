CREATE OR REPLACE PROCEDURE staging.sp_refresh_datamart()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
BEGIN
    SYSTEM$LOG('INFO', 'Fetching remote repo');
    ALTER GIT REPOSITORY public.git_repo_stage_world_triathlon FETCH;
    SYSTEM$LOG('INFO', 'Executing src/dml/datamart/dim_event.sql');
    EXECUTE IMMEDIATE FROM @public.git_repo_stage_world_triathlon/branches/develop/src/dml/datamart/dim_event.sql;
    SYSTEM$LOG('INFO', 'Executing src/dml/datamart/dim_program.sql');
    EXECUTE IMMEDIATE FROM @public.git_repo_stage_world_triathlon/branches/develop/src/dml/datamart/dim_program.sql;
    SYSTEM$LOG('INFO', 'Executing src/dml/datamart/fct_results.sql');
    EXECUTE IMMEDIATE FROM @public.git_repo_stage_world_triathlon/branches/develop/src/dml/datamart/fct_results.sql;
    SYSTEM$LOG('INFO', 'Executing src/dml/datamart/fct_ranking.sql');
    EXECUTE IMMEDIATE FROM @public.git_repo_stage_world_triathlon/branches/develop/src/dml/datamart/fct_ranking.sql;
    
    RETURN 'Successful refresh';

EXCEPTION
    WHEN OTHER THEN
        -- Log any errors encountered during execution
        SYSTEM$LOG('ERROR', 'Error encountered');
        RETURN 'Error encountered';
END;
$$;
