WITH ids AS (
    SELECT DISTINCT
        event_id,
        prog_id
    FROM world_triathlon.staging.programs
    WHERE is_results = true
    --AND YEAR(prog_date_utc) > 2015
    AND (
        prog_name = 'Elite Women'
        OR prog_name = 'Elite Men'
        )
    )
SELECT
    ids.event_id,
    ids.prog_id,
    PARSE_JSON(json):data.headers::VARIANT AS headers,
    PARSE_JSON(json):data.headers_count::NUMBER AS headers_count,
    PARSE_JSON(json):data.meta::VARIANT AS meta,
    PARSE_JSON(json):data.results::VARIANT AS results,
    PARSE_JSON(json):_metadata:timestamp::TIMESTAMP_NTZ AS load_ts,
FROM ids
CROSS JOIN TABLE(get_json('https://api.triathlon.org/v1/events/'|| ids.event_id ||'/programs/' || ids.prog_id || '/results', 
                          '0201b661afadf43392e4c7dcaed533fe '))
WHERE PARSE_JSON(json):_metadata.status_code = 200

-- url = "https://api.triathlon.org/v1/events/110659/programs/308511/results"
-- 15min
