with int_order_details AS (
    SELECT
        *
    FROM
        {{ ref('stg_northwind__order_details') }}
)
SELECT
    order_id,
    product_id,
    unit_price,
    quantity,
    discount,
    round((unit_price * quantity)::NUMERIC, 2) AS product_total,
	round(((unit_price * quantity) * (1.0 - discount))::NUMERIC, 2) AS product_total_w_discount,
    current_timestamp as load_at
FROM
    int_order_details
