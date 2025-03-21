SET last_page = (
    SELECT PARSE_JSON(json):last_page::NUMBER AS last_page
    FROM TABLE(staging.get_json('https://api.triathlon.org/v1/athletes?category_id=42&per_page=10', 
                                '0201b661afadf43392e4c7dcaed533fe '))
);

INSERT OVERWRITE INTO staging.athletes 
WITH pages AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY SEQ4()) AS page_nb
    FROM TABLE(GENERATOR(ROWCOUNT => $last_page))
)
SELECT
    f.value:athlete_id::NUMBER AS athlete_id,
    f.value:athlete_first::VARCHAR(256) AS athlete_first,
    f.value:athlete_last::VARCHAR(256) AS athlete_last,
    f.value:athlete_gender::VARCHAR(256) AS athlete_gender,
    f.value:athlete_yob::NUMBER AS athlete_yob,
    f.value:athlete_country_id::NUMBER AS athlete_country_id,
    f.value:athlete_country_name::VARCHAR(256) AS athlete_country_name,
    f.value:athlete_categories::ARRAY AS athlete_categories,
    f.value:athlete_api_listing::VARCHAR AS athlete_api_listing,
    f.value:athlete_edit_date::TIMESTAMP_TZ AS athlete_edit_date,
    f.value:athlete_flag::VARCHAR AS athlete_flag,
    f.value:athlete_listing::VARCHAR AS athlete_listing,
    f.value:athlete_noc::VARCHAR(256) AS athlete_noc,
    f.value:athlete_profile_image::VARCHAR AS athlete_profile_image,
    f.value:athlete_slug::VARCHAR(256) AS athlete_slug,
    f.value:neutral_status::VARCHAR(256) AS neutral_status,
    f.value:updated_at::TIMESTAMP_TZ AS updated_at,
    f.value:validated::VARCHAR(256) AS validated,
    PARSE_JSON(t.json):_metadata:timestamp::TIMESTAMP_NTZ AS load_ts
FROM pages
CROSS JOIN TABLE(staging.get_json('https://api.triathlon.org/v1/athletes?category_id=42&per_page=10&page=' || page_nb, 
                                    '0201b661afadf43392e4c7dcaed533fe ')) t,
LATERAL FLATTEN(input => PARSE_JSON(t.json):data) f
WHERE PARSE_JSON(t.json):_metadata.status_code = 200

-- > 1 hour
