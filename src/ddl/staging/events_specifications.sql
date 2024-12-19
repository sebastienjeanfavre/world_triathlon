CREATE OR REPLACE TABLE staging.event_specifications AS 
SELECT
    PARSE_JSON(json):cat_id::NUMBER AS cat_id,
    PARSE_JSON(json):cat_name::VARCHAR(256) AS cat_name,
    PARSE_JSON(json):cat_order::NUMBER AS cat_order,
    PARSE_JSON(json):cat_parent_id::NUMBER AS cat_parent_id,
    PARSE_JSON(json):cat_slug::VARCHAR(256) AS cat_slug,
    PARSE_JSON(json):_metadata.timestamp::TIMESTAMP_NTZ AS load_ts
FROM TABLE(staging.get_json_all_pages('https://api.triathlon.org/v1/events/specifications?show_children=true', 
                              '0201b661afadf43392e4c7dcaed533fe '))
