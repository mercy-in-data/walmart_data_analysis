SELECT
    store_id,
    dept_id,
    COUNT(*) AS row_count
FROM {{ ref('Walmart_store_department_dim') }}
GROUP BY
    store_id,
    dept_id
HAVING COUNT(*) > 1

