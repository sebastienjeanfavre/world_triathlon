WITH top_athletes AS (
    SELECT 
        ranking.rank,
        a.athlete_fullname,
        a.athlete_id,
        CASE
            WHEN ranking.rank < 50 THEN 50
            WHEN ranking.rank BETWEEN 50 AND 100 THEN 100
            WHEN ranking.rank BETWEEN 100 AND 150 THEN 150
            WHEN ranking.rank BETWEEN 150 AND 200 THEN 200
            WHEN ranking.rank BETWEEN 200 AND 250 THEN 250
            WHEN ranking.rank BETWEEN 250 AND 300 THEN 300
            WHEN ranking.rank BETWEEN 300 AND 350 THEN 350
            WHEN ranking.rank BETWEEN 350 AND 400 THEN 400
            WHEN ranking.rank BETWEEN 400 AND 450 THEN 450
            WHEN ranking.rank BETWEEN 450 AND 500 THEN 500
        END AS rank_bucket,
    FROM fct_ranking ranking
    INNER JOIN datamart.dim_athlete a ON a.athlete_id = ranking.athlete_id
    WHERE ranking.ranking_name = 'Elite Women'
    AND ranking.ranking_cat_id = 3 -- 'World Rankings'
    AND ranking.events_current_period > 0
    AND rank < 500
    ORDER BY ranking.rank
    )
SELECT 
    top_athletes.rank_bucket,
    AVG(res.split1_rank) AS avg_swim_rank,
    AVG(res.split3_rank) AS avg_bike_rank,
    AVG(res.split5_rank) AS avg_run_rank,
FROM datamart.fct_results res 
INNER JOIN top_athletes ON top_athletes.athlete_id = res.athlete_id
GROUP BY top_athletes.rank_bucket
ORDER BY top_athletes.rank_bucket
;