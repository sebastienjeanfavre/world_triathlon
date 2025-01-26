SELECT 
    athlete_fullname,
    ROW_NUMBER() OVER (PARTITION BY a.athlete_id ORDER BY prog_date),
    split1_rank/nb_finishers AS relative_swim_rank,
    split3_rank/nb_finishers AS relative_bike_rank,
    split5_rank/nb_finishers AS relative_run_rank,
    e.event_title
FROM datamart.fct_results r
INNER JOIN datamart.dim_event e ON e.event_id = r.event_id
INNER JOIN datamart.dim_athlete a ON a.athlete_id = r.athlete_id
WHERE athlete_fullname = 'Franka Rust'
ORDER BY prog_date