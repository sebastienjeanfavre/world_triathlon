ALTER TABLE world_triathlon.staging.events SET
	DATA_METRIC_SCHEDULE = 'TRIGGER_ON_CHANGES'
;
ALTER TABLE world_triathlon.staging.events
	ADD DATA METRIC FUNCTION snowflake.core.null_count
    	ON (event_id)
;
ALTER TABLE world_triathlon.staging.events
	ADD DATA METRIC FUNCTION snowflake.core.duplicate_count
    	ON (event_id)
;
