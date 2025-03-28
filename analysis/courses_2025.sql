
select table_name, last_altered 
from information_schema.tables
where table_type LIKE '%TABLE%';

SELECT *
FROM datamart.fct_results
ORDER BY prog_date DESC NULLS LAST;

SELECT * 
FROM datamart.dim_event e
-- INNER JOIN datamart.dim_program p ON e.event_id = p.event_id
WHERE YEAR(event_date) = 2025
-- AND specifications[0]:cat_name IN ('Sprint', 'Standard')
ORDER BY event_date
;

