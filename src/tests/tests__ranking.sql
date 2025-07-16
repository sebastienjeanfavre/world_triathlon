ALTER TABLE world_triathlon.staging.ranking SET
	DATA_METRIC_SCHEDULE = 'TRIGGER_ON_CHANGES'
;
ALTER TABLE world_triathlon.staging.ranking
	ADD DATA METRIC FUNCTION snowflake.core.null_count
    	ON (ranking_id)
;
ALTER TABLE world_triathlon.staging.ranking
	ADD DATA METRIC FUNCTION snowflake.core.duplicate_count
    	ON (ranking_id)
;
