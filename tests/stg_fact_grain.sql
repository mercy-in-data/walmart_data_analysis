SELECT
    store_id,
    store_date,
    COUNT(*) AS row_count
FROM {{ ref('stg_fact') }}
GROUP BY
    store_id,
    store_date
HAVING COUNT(*) > 1