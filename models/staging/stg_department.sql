{{ config(
    materialized='incremental'
) }}

SELECT
    Store AS store_id,
    Dept AS dept_id,
    TO_DATE(Date) AS store_date,
    Weekly_Sales AS weekly_sales,
    IsHoliday AS is_holiday,
    _ingested_at,
    _file_name
FROM {{ source('walmart_raw', 'DEPARTMENT') }}

{% if is_incremental() %}

WHERE _ingested_at > (
    SELECT MAX(_ingested_at)
    FROM {{ this }}
)

{% endif %}