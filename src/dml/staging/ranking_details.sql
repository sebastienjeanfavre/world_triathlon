CREATE OR REPLACE TEMP TABLE staging.incoming_ranking_details AS
WITH ranking_ids AS (
    SELECT DISTINCT
        ranking_id
    FROM staging.ranking
    WHERE ranking_id IN (11, 12, 13, 14, 15, 16)
)
SELECT DISTINCT
    ranking_ids.ranking_id,
    f.value:athlete_id::NUMBER AS athlete_id,
    f.value:rank::NUMBER AS rank,
    f.value:total::NUMBER AS total,
    f.value:total_current_period::NUMBER AS total_current_period,
    f.value:events_current_period::NUMBER AS events_current_period,
    f.value:scores_current_period::ARRAY AS scores_current_period,
    f.value:total_previous_period::NUMBER AS total_previous_period,
    f.value:last_rank::NUMBER AS last_rank,
    f.value:last_total::NUMBER AS last_total,
    f.value:events_previous_period::NUMBER AS events_previous_period,
    f.value:scores_previous_period::ARRAY AS scores_previous_period,
    f.value:updated_at::TIMESTAMP_NTZ AS updated_at,
    PARSE_JSON(t.json):_metadata.timestamp::TIMESTAMP_NTZ AS load_ts
FROM ranking_ids
CROSS JOIN TABLE(world_triathlon.staging.get_json_all_pages(
    'https://api.triathlon.org/v1/rankings/'|| ranking_ids.ranking_id, 
    '0201b661afadf43392e4c7dcaed533fe')) t,
LATERAL FLATTEN(input => PARSE_JSON(t.json):rankings) f
WHERE PARSE_JSON(t.json):_metadata.status_code = 200
AND athlete_id IS NOT NULL
AND ranking_id IS NOT NULL
AND rank IS NOT NULL
;

MERGE INTO staging.ranking_details target USING staging.incoming_ranking_details source
    ON target.ranking_id = source.ranking_id 
    AND target.athlete_id = source.athlete_id
    AND target.rank = source.rank
    WHEN MATCHED     
    AND (
        target.total != source.total OR
        target.total_current_period != source.total_current_period OR
        target.events_current_period != source.events_current_period OR
        target.scores_current_period != source.scores_current_period OR
        target.total_previous_period != source.total_previous_period OR
        target.last_rank != source.last_rank OR
        target.last_total != source.last_total OR
        target.events_previous_period != source.events_previous_period OR
        target.scores_previous_period != source.scores_previous_period OR
        target.updated_at != source.updated_at
    )
    THEN 
        UPDATE SET 
            target.total = source.total,
            target.total_current_period = source.total_current_period,
            target.events_current_period = source.events_current_period,
            target.scores_current_period = source.scores_current_period,
            target.total_previous_period = source.total_previous_period,
            target.last_rank = source.last_rank,
            target.last_total = source.last_total,
            target.events_previous_period = source.events_previous_period,
            target.scores_previous_period = source.scores_previous_period,
            target.updated_at = source.updated_at,
            target.load_ts = source.load_ts
    WHEN NOT MATCHED THEN
        INSERT (
            ranking_id, 
            athlete_id, 
            rank, 
            total, 
            total_current_period, 
            events_current_period, 
            scores_current_period, 
            total_previous_period,
            last_rank,
            last_total,
            events_previous_period,
            scores_previous_period,
            updated_at, 
            load_ts
            ) 
        VALUES (
            source.ranking_id,
            source.athlete_id,
            source.rank,
            source.total,
            source.total_current_period,
            source.events_current_period,
            source.scores_current_period,
            source.total_previous_period,
            source.last_rank,
            source.last_total,
            source.events_previous_period,
            source.scores_previous_period,
            source.updated_at,
            source.load_ts
            )
;