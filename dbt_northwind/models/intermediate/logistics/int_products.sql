with int_products AS (
    SELECT
        *
    FROM
        {{ ref('stg_northwind__products') }}
),
int_categories AS (
    SELECT
        *
    FROM
        {{ ref('stg_northwind__categories') }}
)
SELECT
    product_id,
    product_name,
    supplier_id,
    prd.category_id,
    cat.category_name,
    quantity_per_unit,
    unit_price,
    units_in_stock,
    units_on_order,
    discontinued,
    current_timestamp as load_at
FROM
    int_products as prd
LEFT JOIN
    int_categories as cat
    on
        prd.category_id = cat.category_id
