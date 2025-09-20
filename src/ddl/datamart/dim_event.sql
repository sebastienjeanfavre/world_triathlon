CREATE OR REPLACE DYNAMIC TABLE datamart.dim_event
TARGET_LAG = '6 hours'
WAREHOUSE = COMPUTE_WH
AS
SELECT
    event_id,
    event_title,
    event_venue,
    event_status,
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