-- url = "https://api.triathlon.org/v1/events/event_id/programs?is_race=true"
-- only is_race = True

WITH ids AS (
    SELECT DISTINCT --TOP 10
        event_id
    FROM staging.events
)
SELECT
    ids.event_id,
    PARSE_JSON(json):prog_id::NUMBER(16,0) AS prog_id,
    PARSE_JSON(json):prog_name::VARCHAR(64) AS prog_name,
    PARSE_JSON(json):prog_gender::VARCHAR(64) AS prog_gender,
    PARSE_JSON(json):prog_max_age::NUMBER(16,0) AS prog_max_age,
    PARSE_JSON(json):prog_min_age::NUMBER(16,0) AS prog_min_age,
    PARSE_JSON(json):prog_notes::VARCHAR AS prog_notes,
    PARSE_JSON(json):prog_date_utc::DATE AS prog_date_utc,
    PARSE_JSON(json):prog_time_utc::VARCHAR(64) AS prog_time_utc,
    PARSE_JSON(json):prog_timezone_name::VARCHAR(64) AS prog_timezone_name,
    PARSE_JSON(json):prog_timezone_offset::VARCHAR(64) AS prog_timezone_offset,
    PARSE_JSON(json):prog_distance_category::VARCHAR(64) AS prog_distance_category,
    PARSE_JSON(json):prog_distances::VARIANT AS prog_distances,
    PARSE_JSON(json):is_race::BOOLEAN AS is_race,
    PARSE_JSON(json):results::BOOLEAN AS is_results,
    PARSE_JSON(json):live_timing_enabled::BOOLEAN AS is_live_timing_enabled,
    PARSE_JSON(json):team::BOOLEAN AS is_team,
    PARSE_JSON(json):_metadata:timestamp::TIMESTAMP_NTZ AS load_ts,
FROM ids
CROSS JOIN TABLE(get_json_seq_pages('https://api.triathlon.org/v1/events/' || ids.event_id || '/programs?is_race=true&per_page=100', 
                                    '0201b661afadf43392e4c7dcaed533fe '))
WHERE PARSE_JSON(json):_metadata.status_code = 200
;

CREATE OR REPLACE TABLE staging.programs AS (
SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))
);

