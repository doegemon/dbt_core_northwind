WITH mart_orders AS (
	SELECT
		*
	FROM
		{{ ref('orders') }}
),
dim_mth AS (
	SELECT
		date(date_trunc('month', order_date)) AS year_month,
		EXTRACT(YEAR FROM order_date) AS year_ref,
		EXTRACT(MONTH FROM order_date) AS mth_ref,
		SUM(total_order_revenue) AS total_revenue,
		COUNT(DISTINCT order_id) AS total_orders
	FROM
		mart_orders
	GROUP BY
        1, 2, 3
),
dim_ytd AS (
	SELECT
		year_month,
		year_ref,
		mth_ref,
		total_revenue,
		CAST(total_orders AS NUMERIC) AS total_orders,
		SUM(total_revenue) OVER (PARTITION BY year_ref ORDER BY mth_ref) AS revenue_ytd,
		SUM(total_orders) OVER (PARTITION BY year_ref ORDER BY mth_ref) AS orders_ytd
	FROM
		dim_mth
),
dim_calc AS (
	SELECT
		year_month,
		year_ref,
		mth_ref,
		total_revenue,
		total_orders,
		LAG(total_revenue) OVER (PARTITION BY year_ref ORDER BY mth_ref) AS previous_revenue,
		LAG(total_orders) OVER (PARTITION BY year_ref ORDER BY mth_ref) AS previous_orders,
		revenue_ytd,
		orders_ytd
	FROM
		dim_ytd
)
SELECT
	year_month,
	total_revenue,
	total_revenue - previous_revenue AS rev_abs_diff,
	(total_revenue - previous_revenue) / previous_revenue * 100 AS rev_pct_diff,
	revenue_ytd,
	total_orders,
	total_orders - previous_orders AS ord_abs_diff,
	(total_orders - previous_orders) / previous_orders * 100 AS ord_pct_diff,
	orders_ytd
FROM
	dim_calc
ORDER BY
    1
