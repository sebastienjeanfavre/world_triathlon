ALTER TABLE world_triathlon.staging.programs SET
	DATA_METRIC_SCHEDULE = 'TRIGGER_ON_CHANGES'
;
ALTER TABLE world_triathlon.staging.programs
	ADD DATA METRIC FUNCTION snowflake.core.null_count
    	ON (prog_id)
;
ALTER TABLE world_triathlon.staging.programs
	ADD DATA METRIC FUNCTION snowflake.core.duplicate_count
    	ON (prog_id)
;
