SET refresh_start_date = (SELECT ADD_MONTHS(MAX(load_ts), -3) FROM staging.programs);

CREATE OR REPLACE TEMP TABLE staging.incoming_programs AS
WITH ids AS (
    SELECT DISTINCT
        event_id
    FROM staging.events
    WHERE event_date >= $refresh_start_date
)
SELECT
    ids.event_id,
    PARSE_JSON(json):prog_id::NUMBER AS prog_id,
    PARSE_JSON(json):prog_name::VARCHAR(256) AS prog_name,
    PARSE_JSON(json):prog_gender::VARCHAR(256) AS prog_gender,
    PARSE_JSON(json):prog_max_age::NUMBER AS prog_max_age,
    PARSE_JSON(json):prog_min_age::NUMBER AS prog_min_age,
    PARSE_JSON(json):prog_notes::VARCHAR AS prog_notes,
    PARSE_JSON(json):prog_date_utc::DATE AS prog_date_utc,
    PARSE_JSON(json):prog_time_utc::VARCHAR(256) AS prog_time_utc,
    PARSE_JSON(json):prog_timezone_name::VARCHAR(256) AS prog_timezone_name,
    PARSE_JSON(json):prog_timezone_offset::VARCHAR(256) AS prog_timezone_offset,
    PARSE_JSON(json):prog_distance_category::VARCHAR(256) AS prog_distance_category,
    PARSE_JSON(json):prog_distances::VARIANT AS prog_distances,
    PARSE_JSON(json):is_race::BOOLEAN AS is_race,
    PARSE_JSON(json):results::BOOLEAN AS is_results,
    PARSE_JSON(json):live_timing_enabled::BOOLEAN AS is_live_timing_enabled,
    PARSE_JSON(json):team::BOOLEAN AS is_team,
    PARSE_JSON(json):_metadata:timestamp::TIMESTAMP_NTZ AS load_ts
FROM ids
CROSS JOIN TABLE(staging.get_json_all_pages('https://api.triathlon.org/v1/events/' || ids.event_id || '/programs?is_race=true&per_page=100', 
                                    '0201b661afadf43392e4c7dcaed533fe '))
WHERE PARSE_JSON(json):_metadata.status_code = 200
;
-- url = "https://api.triathlon.org/v1/events/event_id/programs?is_race=true"
-- only is_race = True


MERGE INTO staging.programs target USING staging.incoming_programs source
    ON target.event_id = source.event_id AND target.prog_id = source.prog_id
    WHEN MATCHED THEN 
        UPDATE SET 
            target.PROG_NAME = source.PROG_NAME,
            target.PROG_GENDER = source.PROG_GENDER,
            target.PROG_MAX_AGE = source.PROG_MAX_AGE,
            target.PROG_MIN_AGE = source.PROG_MIN_AGE,
            target.PROG_NOTES = source.PROG_NOTES,
            target.PROG_DATE_UTC = source.PROG_DATE_UTC,
            target.PROG_TIME_UTC = source.PROG_TIME_UTC,
            target.PROG_TIMEZONE_NAME = source.PROG_TIMEZONE_NAME,
            target.PROG_TIMEZONE_OFFSET = source.PROG_TIMEZONE_OFFSET,
            target.PROG_DISTANCE_CATEGORY = source.PROG_DISTANCE_CATEGORY,
            target.PROG_DISTANCES = source.PROG_DISTANCES,
            target.IS_RACE = source.IS_RACE,
            target.IS_RESULTS = source.IS_RESULTS,
            target.IS_LIVE_TIMING_ENABLED = source.IS_LIVE_TIMING_ENABLED,
            target.IS_TEAM = source.IS_TEAM,
            target.LOAD_TS = source.LOAD_TS
    WHEN NOT MATCHED THEN
        INSERT
        VALUES (
            source.EVENT_ID,
            source.PROG_ID,
            source.PROG_NAME,
            source.PROG_GENDER,
            source.PROG_MAX_AGE,
            source.PROG_MIN_AGE,
            source.PROG_NOTES,
            source.PROG_DATE_UTC,
            source.PROG_TIME_UTC,
            source.PROG_TIMEZONE_NAME,
            source.PROG_TIMEZONE_OFFSET,
            source.PROG_DISTANCE_CATEGORY,
            source.PROG_DISTANCES,
            source.IS_RACE,
            source.IS_RESULTS,
            source.IS_LIVE_TIMING_ENABLED,
            source.IS_TEAM,
            source.LOAD_TS
        )
;