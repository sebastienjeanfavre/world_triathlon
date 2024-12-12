CREATE TABLE IF NOT EXISTS staging.event_categories AS 
SELECT
    PARSE_JSON(json):cat_id::NUMBER AS cat_id,
    PARSE_JSON(json):cat_name::VARCHAR(256) AS cat_name,
    PARSE_JSON(json):cat_order::NUMBER AS cat_order,
    PARSE_JSON(json):cat_parent_id::NUMBER AS cat_parent_id,
    PARSE_JSON(json):cat_slug::VARCHAR(256) AS cat_slug
FROM TABLE(get_json_all_pages('https://api.triathlon.org/v1/events/categories', 
                                '0201b661afadf43392e4c7dcaed533fe '))
