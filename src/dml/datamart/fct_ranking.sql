-- SELECT GET_DDL('table', 'datamart.fct_ranking');
-- CREATE OR REPLACE TABLE datamart.fct_ranking AS
-- INSERT OVERWRITE INTO datamart.fct_results
SELECT 
    r.ranking_id,
    rd.athlete_id,
    r.ranking_name,
    r.ranking_cat_id,
    r.ranking_cat_name,
    r.region_name,
    rd.events_current_period,
    rd.events_previous_period,
    rd.last_rank,
    rd.last_total,
    rd.rank,
    rd.scores_current_period,
    rd.scores_previous_period,
    rd.total,
    rd.total_current_period,
    rd.total_previous_period,
    rd.updated_at,
    rd.load_ts
FROM staging.ranking r
JOIN staging.ranking_details rd ON r.ranking_id = rd.ranking_id,
