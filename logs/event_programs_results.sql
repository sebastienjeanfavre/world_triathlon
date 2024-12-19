select 'events' as table_name, to_date(load_ts), count(*) from staging.events
group by table_name, to_date(load_ts)
union all
select 'programs' as table_name, to_date(load_ts), count(*) from staging.programs
group by table_name, to_date(load_ts)
union all
select 'results' as table_name, to_date(load_ts), count(*) from staging.programs_results
group by table_name, to_date(load_ts)