INSERT OVERWRITE INTO staging.programs_entries
WITH ids AS (
    SELECT DISTINCT
        event_id,
        prog_id
    FROM world_triathlon.staging.programs
    WHERE prog_date_utc > CURRENT_DATE()
    AND prog_name IN (
        'Elite Women', 
        'Elite Men',
        'Junior Men',
        'Junior Women',
        'U23 Men',
        'U23 Women'
    )
)
SELECT
    ids.event_id,
    ids.prog_id,
    PARSE_JSON(json):data.headers::VARIANT AS headers,
    PARSE_JSON(json):data.headers_count::NUMBER AS headers_count,
    PARSE_JSON(json):data.entries::VARIANT AS entries,
    PARSE_JSON(json):_metadata:timestamp::TIMESTAMP_NTZ AS load_ts,
FROM ids
CROSS JOIN TABLE(staging.get_json('https://api.triathlon.org/v1/events/'|| ids.event_id ||'/programs/' || ids.prog_id || '/entries?type=start', 
    '0201b661afadf43392e4c7dcaed533fe '))
WHERE PARSE_JSON(json):_metadata.status_code = 200
AND ARRAY_SIZE(entries) > 0
;

