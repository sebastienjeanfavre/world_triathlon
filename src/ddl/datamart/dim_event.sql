CREATE OR REPLACE DYNAMIC TABLE datamart.dim_event
TARGET_LAG = '6 hours'
WAREHOUSE = SWISS_TRIATHLON_WH
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
    IFF(ARRAY_CONTAINS('World Cup'::VARIANT, event_cat_list), TRUE, FALSE) AS is_world_cup,
    IFF(ARRAY_CONTAINS('Continental Cup'::VARIANT, event_cat_list), TRUE, FALSE) AS is_continental_cup,
    IFF(ARRAY_CONTAINS('World Championships'::VARIANT, event_cat_list), TRUE, FALSE) AS is_world_championships,
    IFF(ARRAY_CONTAINS('World Championship Series'::VARIANT, event_cat_list), TRUE, FALSE) AS is_world_championship_series,
    IFF(ARRAY_CONTAINS('Major Games'::VARIANT, event_cat_list), TRUE, FALSE) AS is_major_games,
    IFF(ARRAY_CONTAINS('World Championship Finals'::VARIANT, event_cat_list), TRUE, FALSE) AS is_world_championship_finals,
    IFF(ARRAY_CONTAINS('Continental Junior Cup'::VARIANT, event_cat_list), TRUE, FALSE) AS is_continental_junior_cup,
    IFF(ARRAY_CONTAINS('Continental Championships'::VARIANT, event_cat_list), TRUE, FALSE) AS is_continental_championships,
    ARRAY_AGG(specs.value:cat_name::VARCHAR) AS event_spec_list,
    IFF(ARRAY_CONTAINS('Standard'::VARIANT, event_spec_list), TRUE, FALSE) AS is_standard,
    IFF(ARRAY_CONTAINS('Relay'::VARIANT, event_spec_list), TRUE, FALSE) AS is_relay,
    IFF(ARRAY_CONTAINS('Sprint'::VARIANT, event_spec_list), TRUE, FALSE) AS is_sprint,
    IFF(ARRAY_CONTAINS('Mixed Relay'::VARIANT, event_spec_list), TRUE, FALSE) AS is_mixed_relay,
    IFF(ARRAY_CONTAINS('Super Sprint'::VARIANT, event_spec_list), TRUE, FALSE) AS is_super_sprint,
    triathlonlive,
    load_ts
FROM staging.events,
LATERAL FLATTEN(input => event_categories) cats,
LATERAL FLATTEN(input => event_specifications) specs,
GROUP BY ALL
;

-- ALTER DYNAMIC TABLE datamart.dim_event REFRESH;