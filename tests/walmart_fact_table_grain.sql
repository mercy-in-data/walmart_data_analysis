SELECT
    store_id,
    dept_id,
    date_id,
    COUNT(*) AS row_count
FROM {{ ref('Walmart_fact_table') }}
GROUP BY
    store_id,
    dept_id,
    date_id
HAVING COUNT(*) > 1
