WITH stg_order_details AS (
  SELECT
    *
  FROM
    {{ source('northwind', 'order_details') }}
)
SELECT
  *,
  current_timestamp as load_at
FROM
  stg_order_details
