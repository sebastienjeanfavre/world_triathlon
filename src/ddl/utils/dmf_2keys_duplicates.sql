CREATE OR REPLACE DATA METRIC FUNCTION governance.dmf_2keys_duplicates(
	arg_t TABLE(
		key1 NUMBER,
		key2 NUMBER
	)
)
RETURNS NUMBER
AS
$$
	SELECT 
		COALESCE(SUM(cnt - 1), 0)
	FROM (
		SELECT 
			key1,
			key2,
			COUNT(*) AS cnt
		FROM arg_t
		GROUP BY key1, key2
		HAVING COUNT(*) > 1
	)
$$;