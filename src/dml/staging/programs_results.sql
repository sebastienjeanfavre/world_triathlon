SET refresh_start_date = (SELECT ADD_MONTHS(MAX(load_ts), -3) FROM staging.programs_results);

CREATE OR REPLACE TEMP TABLE staging.incoming_programs_results AS
WITH ids AS (
    SELECT DISTINCT
        event_id,
        prog_id
    FROM world_triathlon.staging.programs
    WHERE is_results = true
    AND prog_date_utc > $refresh_start_date
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
    PARSE_JSON(json):data.meta::VARIANT AS meta,
    PARSE_JSON(json):data.results::VARIANT AS results,
    PARSE_JSON(json):_metadata:timestamp::TIMESTAMP_NTZ AS load_ts,
FROM ids
CROSS JOIN TABLE(staging.get_json('https://api.triathlon.org/v1/events/'|| ids.event_id ||'/programs/' || ids.prog_id || '/results', 
                          '0201b661afadf43392e4c7dcaed533fe '))
WHERE PARSE_JSON(json):_metadata.status_code = 200
AND event_id IS NOT NULL
AND prog_id IS NOT NULL
;
-- url = "https://api.triathlon.org/v1/events/110659/programs/308511/results"
-- 15min

MERGE INTO staging.programs_results target USING staging.incoming_programs_results source
    ON target.event_id = source.event_id AND target.prog_id = source.prog_id
    WHEN MATCHED THEN 
        UPDATE SET 
            target.headers = source.headers,
            target.headers_count = source.headers_count,
            target.meta = source.meta,
            target.results = source.results,
            target.load_ts = source.load_ts
    WHEN NOT MATCHED THEN
        INSERT (event_id, prog_id, headers, headers_count, meta, results, load_ts) 
        VALUES (
            source.event_id,
            source.prog_id,
            source.headers,
            source.headers_count,
            source.meta,
            source.results,
            source.load_ts
        )
