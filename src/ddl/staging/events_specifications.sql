CREATE TABLE IF NOT EXISTS staging.event_specifications AS 
SELECT
    PARSE_JSON(json):cat_id::NUMBER(16,0) AS cat_id,
    PARSE_JSON(json):cat_name::VARCHAR AS cat_name,
    PARSE_JSON(json):cat_order::NUMBER(16,0) AS cat_order,
    PARSE_JSON(json):cat_parent_id::NUMBER(16,0) AS cat_parent_id,
    PARSE_JSON(json):cat_slug::VARCHAR AS cat_slug,
    PARSE_JSON(json):_metadata.timestamp::TIMESTAMP_NTZ AS load_ts
FROM TABLE(get_json_all_pages('https://api.triathlon.org/v1/events/specifications?show_children=true', 
                              '0201b661afadf43392e4c7dcaed533fe '))
