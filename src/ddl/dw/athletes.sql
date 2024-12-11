CREATE TABLE IF NOT EXISTS dw.athletes (
    athlete_id NUMBER ,
    athlete_first VARCHAR,
    athlete_last VARCHAR,
    athlete_name VARCHAR,
    athlete_yob NUMBER,
    athlete_country_id NUMBER,
    athlete_country_name VARCHAR,
    athlete_categories VARIANT,
    athlete_edit_date DATE,
    athlete_noc VARCHAR,
    updated_at DATE,
    load_ts TIMESTAMP_NTZ
    CONSTRAINT athlete_pk PRIMARY KEY (athlete_id)
)