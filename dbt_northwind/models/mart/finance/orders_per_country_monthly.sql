WITH dim_orders AS (
	SELECT DISTINCT
		country_code,
		country,
		order_date,
		order_id,
		total_order_revenue,
		total_order_revenue_w_discount
	FROM
		{{ ref('orders') }}
)
SELECT
	country_code,
	country,
	date(date_trunc('month', order_date)) AS year_month,
	COUNT(DISTINCT order_id) AS total_orders,
	SUM(total_order_revenue) AS total_revenue,
	ROUND(SUM(total_order_revenue) / COUNT(DISTINCT order_id), 2) AS avg_order_revenue,
	SUM(total_order_revenue_w_discount) AS total_revenue_w_discount,
	ROUND(SUM(total_order_revenue_w_discount) / COUNT(DISTINCT order_id), 2) AS avg_order_revenue_discount
FROM
	dim_orders
GROUP BY
    1, 2, 3
ORDER BY
	1, 2, 3
