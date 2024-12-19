CREATE OR REPLACE PROCEDURE sp_refresh_staging()
RETURNS TABLE (table_name STRING, rows_inserted INTEGER)
LANGUAGE SQL
AS
$$
DECLARE
  rows_inserted INTEGER;
BEGIN
    EXECUTE IMMEDIATE FROM  @git_repo_stage_world_triathlon/branches/main/src/dml/staging/dim_event.sql;
END;
$$;
