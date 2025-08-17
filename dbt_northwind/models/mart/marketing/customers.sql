with int_customers as (
	SELECT
		*
	FROM
        {{ ref('int_customers') }}
),
mart_orders as (
	SELECT
		*
	FROM
        {{ ref('orders') }}
),
customer_orders as (
	SELECT
		customer_id,
		min(order_date) as first_order_date,
		max(order_date) as last_order_date,
		count(distinct order_id) as total_orders,
		sum(total_order_revenue) as lifetime_value
    FROM
		mart_orders
	GROUP BY
		1
)
SELECT
	cus.country_code,
	cus.customer_id,
	cus.company_name,
	co.first_order_date,
	co.last_order_date,
	coalesce(co.total_orders, 0) as total_orders,
	co.lifetime_value,
	current_timestamp as load_at
FROM
	int_customers AS cus
LEFT JOIN
	customer_orders AS co
	ON
		cus.customer_id = co.customer_id
