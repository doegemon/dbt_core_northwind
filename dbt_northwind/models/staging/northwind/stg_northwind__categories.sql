WITH stg_categories AS (
  SELECT
    *
  FROM
    {{ source('northwind', 'categories') }}
)
SELECT
  category_id,
  category_name,
  description,
  current_timestamp as load_at
FROM
  stg_categories
