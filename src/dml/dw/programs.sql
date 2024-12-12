SELECT
    prog_id,
    event_id,
    prog_name,
    prog_gender,
    prog_max_age,
    prog_min_age,
    prog_notes,
    prog_date_utc,
    prog_time_utc,
    prog_timezone_offset,
    prog_distance_category,
    prog_distances,
    is_race,
    is_results,
    is_live_timing_enabled,
    is_team,
    load_ts
FROM world_triathlon.staging.programs

-- Test --
-- uniqueness of prog_id