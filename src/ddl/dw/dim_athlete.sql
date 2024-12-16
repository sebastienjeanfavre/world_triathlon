CREATE TABLE IF NOT EXISTS dw.dim_athlete (
    athlete_id NUMBER ,
    athlete_first VARCHAR(256),
    athlete_last VARCHAR(256),
    athlete_name VARCHAR(256),
    athlete_yob NUMBER,
    athlete_country_id NUMBER,
    athlete_country_name VARCHAR(256),
    athlete_categories VARIANT,
    athlete_edit_date DATE,
    athlete_noc VARCHAR(256),
    updated_at DATE,
    load_ts TIMESTAMP_NTZ
    CONSTRAINT athlete_pk PRIMARY KEY (athlete_id)
)