INSERT OVERWRITE INTO datamart.dim_event
SELECT 
    event_id,
    event_title,
    event_venue,
    event_status
    event_date,
    event_finish_date,
    event_edit_date,
    event_country,
    event_region_name,
    event_latitude,
    event_longitude,
    event_categories,
    event_specifications,
    triathlonlive,
    load_ts
FROM staging.events

-- Test --
-- uniqueness of event_id