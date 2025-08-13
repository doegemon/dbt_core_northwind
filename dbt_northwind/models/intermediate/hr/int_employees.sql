with int_employees AS (
    SELECT
        *
    FROM
        {{ ref('stg_northwind__employees') }}
)
SELECT
    empl.employee_id,
    last_name,
    first_name,
    concat(first_name, ' ', last_name) as full_name,
    title,
    birth_date,
    hire_date,
    sal.annual_salary,
    address,
    city,
    region,
    postal_code,
    empl.country,
    iso.country_iso_2 as country_code,
    home_phone,
    notes,
    reports_to,
    current_timestamp as load_at
FROM
    int_employees as empl
LEFT JOIN
    {{ ref('country_iso') }} as iso
    on
        empl.country = iso.country
LEFT JOIN
    {{ ref('employee_salary') }} as sal
    on
        empl.employee_id = sal.employee_id
