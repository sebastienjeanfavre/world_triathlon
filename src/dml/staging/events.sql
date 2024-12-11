SET start_date = (
    SELECT
        TO_DATE(COALESCE(MAX(load_ts), '1900-01-01'))::VARCHAR AS start_date
    FROM world_triathlon.staging.events
)
;

SET last_page = (
    SELECT 
        PARSE_JSON(json):last_page::INT AS last_page,
    FROM TABLE(get_json('https://api.triathlon.org/v1/events?start_date=' || $start_date || '&per_page=100&category_id=340%7C341%7C351%7C624%7C348%7C349&specification_id=376%7C377&order=asc&page=1', '0201b661afadf43392e4c7dcaed533fe '))
)
;

WITH pages AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY SEQ4()) AS page_nb
    FROM TABLE(GENERATOR(ROWCOUNT => $last_page))
)
SELECT
    f.value:event_id::NUMBER(16,0) AS event_id,
    f.value:event_title::VARCHAR AS event_title,
    f.value:event_date::DATE AS event_date,
    f.value:event_finish_date::DATE AS event_finish_date,
    f.value:event_edit_date::DATE AS event_edit_date,
    f.value:event_country_id::NUMBER(16,0) AS event_country_id,
    f.value:event_country::VARCHAR AS event_country,
    f.value:event_region_name::VARCHAR AS event_region_name,
    f.value:event_specifications::VARIANT AS specifications,
    f.value:triathlonlive::BOOLEAN AS triathlonlive,
    PARSE_JSON(t.json):_metadata:timestamp::TIMESTAMP_NTZ AS load_ts
FROM pages
CROSS JOIN TABLE(world_triathlon.staging.get_json(
    'https://api.triathlon.org/v1/events?start_date=' || $start_date || '&per_page=100&category_id=340%7C341%7C351%7C624%7C348%7C349&specification_id=376%7C377&order=asc&page=' || page_nb, 
    '0201b661afadf43392e4c7dcaed533fe ')) t,
LATERAL FLATTEN(input => PARSE_JSON(t.json):data) f
WHERE PARSE_JSON(t.json):_metadata.status_code = 200

-- select * from event_categories;
-- 340 -- Continental Championships
-- 341 -- Continental Cup
-- 624 -- World Championship Finals
-- 351 -- World Championship Series
-- 348 -- World Championships
-- 349 -- World Cup

-- 340|341|351|624|348|349

-- select distinct event_specifications from events;
-- 376|377 -- Sprint|OD
