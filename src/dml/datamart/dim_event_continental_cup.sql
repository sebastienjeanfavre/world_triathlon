INSERT OVERWRITE INTO datamart.dim_event_continental_cup
SELECT
    e.event_id,
    e.event_title,
    f.value:cat_name::VARCHAR AS cat_name,
    e.event_country,
    e.event_venue,
    e.event_status,
    e.event_date,
    e.event_finish_date,
    e.event_edit_date,
    e.event_region_name,
    e.event_latitude,
    e.event_longitude,
    e.event_categories,
    e.event_specifications,
    e.triathlonlive,
    e.load_ts
FROM staging.events e,
LATERAL FLATTEN(input => event_categories) f
WHERE cat_name = 'Continental Cup'
;
-- Test --
-- uniqueness of event_id