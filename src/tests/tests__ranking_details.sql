ALTER TABLE world_triathlon.staging.ranking_details SET
	DATA_METRIC_SCHEDULE = 'TRIGGER_ON_CHANGES'
;
ALTER TABLE world_triathlon.staging.ranking_details
	ADD DATA METRIC FUNCTION snowflake.core.null_count
    	ON (ranking_id)
;
ALTER TABLE world_triathlon.staging.ranking_details
	ADD DATA METRIC FUNCTION snowflake.core.null_count
    	ON (athlete_id)
;