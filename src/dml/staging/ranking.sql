-- INSERT OVERWRITE INTO staging.ranking
SELECT 
    PARSE_JSON(t.json):ranking_id::NUMBER AS ranking_id,
    PARSE_JSON(t.json):ranking_name::VARCHAR(256) AS ranking_name,
    PARSE_JSON(t.json):ranking_cat_id::NUMBER AS ranking_cat_id,
    PARSE_JSON(t.json):ranking_cat_name::VARCHAR(256) AS ranking_cat_name,
    PARSE_JSON(t.json):region_id::NUMBER AS region_id,
    PARSE_JSON(t.json):region_name::VARCHAR(256) AS region_name,
    PARSE_JSON(t.json):week::VARCHAR(256) AS week,
    PARSE_JSON(t.json):published::TIMESTAMP_NTZ AS published,
    PARSE_JSON(t.json):_metadata.timestamp::TIMESTAMP_NTZ AS load_ts
FROM TABLE(world_triathlon.staging.get_json_all_pages(
    'https://api.triathlon.org/v1/rankings', 
    '0201b661afadf43392e4c7dcaed533fe ')) t
WHERE PARSE_JSON(t.json):_metadata.status_code = 200;

