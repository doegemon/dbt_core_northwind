WITH stg_suppliers AS (
  SELECT
    *
  FROM
    {{ source('northwind', 'suppliers') }}
)
SELECT
  *,
  current_timestamp as load_at
FROM
  stg_suppliers
