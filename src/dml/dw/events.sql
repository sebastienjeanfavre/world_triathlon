SELECT 
    event_id,
    event_title,
    event_date,
    event_finish_date,
    event_edit_date,
    event_country_id,
    event_country,
    event_region_name,
    specifications,
    triathlonlive,
    load_ts,
FROM world_triathlon.staging.events

-- Test --
-- uniqueness of event_id