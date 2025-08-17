WITH int_products AS (
	SELECT
		*
	FROM
		{{ ref('int_products') }}
),
int_order_details AS (
	SELECT
		*
	FROM
		{{ ref('int_order_details') }}
)
SELECT
	ip.product_id,
	ip.product_name,
	ip.category_name,
	COUNT(DISTINCT iod.order_id) as total_product_orders,
	SUM(iod.product_total) as total_product_revenue,
    ROW_NUMBER() OVER (ORDER BY SUM(iod.product_total) DESC) AS product_rank
FROM
	int_products AS ip
JOIN
	int_order_details AS iod
	ON
		ip.product_id = iod.product_id
GROUP BY
	1, 2, 3
ORDER BY
	5 DESC
