ALTER TABLE world_triathlon.staging.athletes SET
	DATA_METRIC_SCHEDULE = 'TRIGGER_ON_CHANGES'
;
ALTER TABLE world_triathlon.staging.athletes
	ADD DATA METRIC FUNCTION snowflake.core.null_count
    	ON (athlete_id)
;
ALTER TABLE world_triathlon.staging.athletes
	ADD DATA METRIC FUNCTION snowflake.core.duplicate_count
    	ON (athlete_id)
;
