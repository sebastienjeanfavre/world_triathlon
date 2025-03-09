WITH top_athletes AS (
    SELECT 
        ranking.rank,
        a.athlete_fullname,
        a.athlete_id,
        CASE
            WHEN ranking.rank <= 10 THEN 10
            WHEN ranking.rank <= 20 THEN 20
            WHEN ranking.rank <= 30 THEN 30
            WHEN ranking.rank <= 40 THEN 40
            WHEN ranking.rank <= 50 THEN 50
            WHEN ranking.rank <= 60 THEN 60
            WHEN ranking.rank <= 70 THEN 70
            WHEN ranking.rank <= 80 THEN 80
            WHEN ranking.rank <= 90 THEN 90
            WHEN ranking.rank <= 100 THEN 100
            WHEN ranking.rank <= 120 THEN 120
            WHEN ranking.rank <= 140 THEN 140
            WHEN ranking.rank <= 160 THEN 160
            WHEN ranking.rank <= 180 THEN 180
            WHEN ranking.rank <= 200 THEN 200
        END AS rank_bucket,
    FROM datamart.fct_ranking ranking
    INNER JOIN datamart.dim_athlete a ON a.athlete_id = ranking.athlete_id
    WHERE ranking.ranking_name = 'Elite Women'
    AND ranking.ranking_cat_id = 3 -- 'World Rankings'
    AND ranking.events_current_period > 0
    AND rank <= 200
    ORDER BY ranking.rank
    ),
res AS (
    SELECT *
    FROM datamart.fct_results
    QUALIFY 10 >= ROW_NUMBER() OVER (PARTITION BY athlete_id ORDER BY prog_date DESC)
)
SELECT 
    top_athletes.rank_bucket,
    AVG(res.split1_rank) AS avg_swim_rank,
    AVG(res.split3_rank) AS avg_bike_rank,
    AVG(res.split5_rank) AS avg_run_rank,
FROM res 
INNER JOIN top_athletes ON top_athletes.athlete_id = res.athlete_id
GROUP BY top_athletes.rank_bucket
ORDER BY top_athletes.rank_bucket
;