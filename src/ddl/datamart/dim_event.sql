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
    ARRAY_AGG(cats.value:cat_name::VARCHAR) AS event_cat_list,
    ARRAY_AGG(specs.value:cat_name::VARCHAR) AS event_spec_list,
    triathlonlive,
    load_ts
FROM staging.events,
LATERAL FLATTEN(input => event_categories) cats,
LATERAL FLATTEN(input => event_specifications) specs,
GROUP BY ALL
;

-- ALTER DYNAMIC TABLE datamart.dim_event REFRESH;