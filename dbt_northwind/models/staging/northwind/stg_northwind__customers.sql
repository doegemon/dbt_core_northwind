WITH stg_customers AS (
  SELECT
    *
  FROM
    {{ source('northwind', 'customers') }}
)
SELECT
  *,
  current_timestamp as load_at
FROM
  stg_customers
