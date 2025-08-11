WITH stg_employees AS (
  SELECT
    *
  FROM
    {{ source('northwind', 'employees') }}
)
SELECT
  *,
  current_timestamp as load_at
FROM
  stg_employees
