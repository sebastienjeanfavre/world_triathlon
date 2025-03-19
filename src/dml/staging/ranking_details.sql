INSERT OVERWRITE INTO staging.ranking_details
SELECT 
    r.ranking_id,
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
FROM staging.ranking r
CROSS JOIN TABLE(world_triathlon.staging.get_json_all_pages(
    'https://api.triathlon.org/v1/rankings/'|| r.ranking_id, 
    '0201b661afadf43392e4c7dcaed533fe ')) t,
LATERAL FLATTEN(input => PARSE_JSON(t.json):rankings) f
WHERE PARSE_JSON(t.json):_metadata.status_code = 200
