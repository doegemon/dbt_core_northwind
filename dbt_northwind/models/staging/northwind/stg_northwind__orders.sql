WITH stg_orders AS (
  SELECT
    *
  FROM
    {{ source('northwind', 'orders') }}
)
SELECT
  *,
  current_timestamp as load_at
FROM
  stg_orders
