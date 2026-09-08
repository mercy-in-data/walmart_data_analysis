SELECT
    store_id,
    dept_id,
    store_date,
    COUNT(*) AS row_count
FROM {{ ref('stg_department') }}
GROUP BY
    store_id,
    dept_id,
    store_date
HAVING COUNT(*) > 1