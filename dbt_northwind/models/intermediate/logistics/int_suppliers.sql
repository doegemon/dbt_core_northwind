with int_suppliers AS (
    SELECT
        *
    FROM
        {{ ref('stg_northwind__suppliers') }}
)
SELECT
    supplier_id,
    company_name,
    contact_name,
    contact_title,
    address,
    city,
    region,
    postal_code,
    sup.country,
    iso.country_iso_2 as country_code,
    phone,
    fax,
    current_timestamp as load_at
FROM
    int_suppliers as sup
LEFT JOIN
    {{ ref('country_iso') }} as iso
    on
        sup.country = iso.country
