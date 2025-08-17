WITH mart_customers AS (
	SELECT
		*
	FROM
		{{ ref('customers') }}
)
SELECT
	country_code,
	customer_id,
	company_name,
	lifetime_value,
	NTILE(5) OVER(ORDER BY lifetime_value DESC) AS group_cluster
FROM
	mart_customers
WHERE
	lifetime_value IS NOT NULL
ORDER BY
	4 DESC
