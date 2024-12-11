SELECT 
    athlete_id,
    athlete_first,
    athlete_last,
    athlete_first || ' ' || athlete_last AS athlete_name,
    athlete_yob,
    athlete_country_id,
    athlete_country_name,
    athlete_categories,
    athlete_edit_date,
    athlete_noc,
    updated_at,
    load_ts
FROM staging.athletes

-- Tests --
-- uniqueness of athlete_id
