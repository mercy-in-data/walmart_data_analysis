{{ config(
    materialized='incremental'
) }}

SELECT
    Store AS store_id,
    TO_DATE(Date) AS store_date,
    Temperature AS temperature,
    Fuel_Price AS fuel_price,
    MarkDown1 AS markdown1,
    MarkDown2 AS markdown2,
    MarkDown3 AS markdown3,
    MarkDown4 AS markdown4,
    MarkDown5 AS markdown5,
    CPI AS cpi,
    Unemployment AS unemployment,
    IsHoliday AS is_holiday,
    _ingested_at,
    _file_name
FROM {{ source('walmart_raw', 'FACT') }}

{% if is_incremental() %}

WHERE _ingested_at > (
    SELECT MAX(_ingested_at)
    FROM {{ this }}
)

{% endif %}