WITH stg_products AS (
  SELECT
    *
  FROM
    {{ source('northwind', 'products') }}
)
SELECT
  *,
  current_timestamp as load_at
FROM
  stg_products
