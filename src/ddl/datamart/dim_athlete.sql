CREATE OR REPLACE DYNAMIC TABLE datamart.dim_athlete
TARGET_LAG = '6 hours'
WAREHOUSE = SWISS_TRIATHLON_WH
AS
SELECT
    athlete_id,
    athlete_first,
    athlete_last,
    athlete_first || ' ' || athlete_last AS athlete_fullname,
    athlete_gender,
    athlete_yob,
    athlete_country_id,
    athlete_country_name,
    athlete_categories,
    athlete_edit_date,
    athlete_noc,
    updated_at,
    load_ts
FROM staging.athletes
;

-- ALTER DYNAMIC TABLE datamart.dim_athlete REFRESH;