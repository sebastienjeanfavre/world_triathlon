CREATE TABLE IF NOT EXISTS dw.events (
    event_id NUMBER ,
    event_title VARCHAR(256),
    event_date DATE,
    event_finish_date DATE,
    event_edit_date DATE,
    event_country_id NUMBER,
    event_country VARCHAR(256),
    event_region_name VARCHAR(256),
    specifications VARIANT,
    triathlonlive BOOLEAN,
    load_ts TIMESTAMP_NTZ,
    CONSTRAINT event_pk PRIMARY KEY (event_id)
)