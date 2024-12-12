CREATE TABLE test.api_sample_athletes AS
SELECT * FROM TABLE(staging.get_json('https://api.triathlon.org/v1/athletes?category_id=42&per_page=1000', '0201b661afadf43392e4c7dcaed533fe'))
;

CREATE TABLE test.api_sample_events AS
SELECT * FROM TABLE(staging.get_json('https://api.triathlon.org/v1/events?per_page=100&category_id=340%7C341%7C351%7C624%7C348%7C349&specification_id=376%7C377&order=asc&page=1', '0201b661afadf43392e4c7dcaed533fe '))
;

CREATE TABLE test.api_sample_programs_results AS
SELECT * FROM TABLE(staging.get_json('https://api.triathlon.org/v1/events/183768/programs/628072/results', 
                          '0201b661afadf43392e4c7dcaed533fe '))
;

CREATE TABLE test.api_sample_programs AS
SELECT * FROM TABLE(staging.get_json_all_pages('https://api.triathlon.org/v1/events/183768/programs?is_race=true&per_page=100', 
                                    '0201b661afadf43392e4c7dcaed533fe '))
;