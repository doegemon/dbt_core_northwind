with int_customers AS (
    SELECT
        *
    FROM
        {{ ref( 'stg_northwind__customers') }}
)
SELECT
    customer_id,
    company_name,
    contact_name,
    contact_title,
    address,
    city,
    region,
    postal_code,
    cus.country,
    iso.country_iso_2 as country_code,
    phone,
    fax,
    current_timestamp as load_at
FROM
    int_customers as cus
LEFT JOIN
    {{ ref('country_iso') }} as iso
    on
        cus.country = iso.country
