WITH int_orders AS (
	SELECT
		*
	FROM
        {{ ref('int_orders') }}
),
int_order_details AS (
	SELECT
		*
	FROM
        {{ ref('int_order_details') }}
),
order_value AS (
	SELECT
		order_id,
		count(distinct product_id) AS total_products,
		sum(quantity) AS total_products_quantity,
		sum(product_total) AS total_order_revenue,
		sum(product_total_w_discount) AS total_order_revenue_w_discount
	FROM
		int_order_details
	GROUP BY
		1
)
SELECT
	o.ship_to_customer_country_code AS country_code,
    o.ship_to_customer_country AS country,
	o.order_id,
	o.customer_id,
	o.order_date,
	o.required_date,
	o.shipped_date,
	coalesce(ov.total_order_revenue, 0) as total_order_revenue,
	coalesce(ov.total_order_revenue_w_discount, 0) as total_order_revenue_w_discount,
	o.freight,
	coalesce(ov.total_products, 0) as total_products,
	coalesce(ov.total_products_quantity, 0) as total_products_quantity,
	o.employee_id,
	current_timestamp as load_at
FROM
	int_orders AS o
LEFT JOIN
	order_value AS ov
	ON
		o.order_id = ov.order_id
