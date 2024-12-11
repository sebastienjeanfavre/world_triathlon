CREATE OR REPLACE TABLE staging.athletes_categories AS
SELECT
    PARSE_JSON(json):cat_id::NUMBER(16,0) AS cat_id,
    PARSE_JSON(json):cat_name::VARCHAR AS cat_name,
    PARSE_JSON(json):cat_order::NUMBER(16,0) AS cat_order,
    PARSE_JSON(json):cat_parent_id::NUMBER(16,0) AS cat_parent_id,
    PARSE_JSON(json):cat_slug::VARCHAR AS cat_slug
FROM TABLE(get_json_all_pages('https://api.triathlon.org/v1/athletes/categories', 
                                '0201b661afadf43392e4c7dcaed533fe '))
