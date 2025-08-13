with int_orders AS (
    SELECT
        *
    FROM
        {{ ref('stg_northwind__orders') }}
)
SELECT
    order_id,
    customer_id,
    employee_id,
    order_date,
    required_date,
    shipped_date,
    ship_via,
    freight,
    ship_name AS ship_to_customer_name,
    ship_address AS ship_to_customer_address,
    ship_city AS ship_to_customer_city,
    ship_region AS ship_to_customer_region,
    ship_postal_code AS ship_to_customer_postal_code,
    ship_country AS ship_to_customer_country,
    iso.country_iso_2 as ship_to_customer_country_code,
    current_timestamp as load_at
FROM
    int_orders as ord
LEFT JOIN
    {{ ref('country_iso') }} as iso
    on
        ord.ship_country = iso.country
