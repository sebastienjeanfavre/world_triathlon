SET last_page = (
    SELECT 
        PARSE_JSON(json):last_page::NUMBER AS last_page,
    FROM TABLE(staging.get_json(
        'https://api.triathlon.org/v1/events?per_page=500&specification_id=357&order=asc&page=1', 
        '0201b661afadf43392e4c7dcaed533fe '))
)
;

-- INSERT OVERWRITE INTO staging.events
CREATE OR REPLACE TABLE staging.events AS
WITH pages AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY SEQ4()) AS page_nb
    FROM TABLE(GENERATOR(ROWCOUNT => $last_page))
)
SELECT
    f.value:event_id::NUMBER AS event_id,
    f.value:event_title::VARCHAR(256) AS event_title,
    f.value:event_venue::VARCHAR(256) AS event_venue,
    f.value:event_status::VARCHAR(256) AS event_status,
    f.value:event_date::DATE AS event_date,
    f.value:event_finish_date::DATE AS event_finish_date,
    f.value:event_edit_date::DATE AS event_edit_date,
    f.value:event_country::VARCHAR(256) AS event_country,
    f.value:event_region_name::VARCHAR(256) AS event_region_name,
    f.value:event_latitude::FLOAT AS event_latitude,
    f.value:event_longitude::FLOAT AS event_longitude,
    f.value:event_specifications::VARIANT AS specifications,
    f.value:triathlonlive::BOOLEAN AS triathlonlive,
    PARSE_JSON(t.json):_metadata:timestamp::TIMESTAMP_NTZ AS load_ts
FROM pages
CROSS JOIN TABLE(world_triathlon.staging.get_json(
    'https://api.triathlon.org/v1/events?per_page=500&specification_id=357&order=asc&page=' || page_nb, 
    '0201b661afadf43392e4c7dcaed533fe ')) t,
LATERAL FLATTEN(input => PARSE_JSON(t.json):data) f
WHERE PARSE_JSON(t.json):_metadata.status_code = 200

-- specification: 357 -- Triathlon
--  ; select * from staging.event_categories;
--  ; select * from staging.event_specifications;