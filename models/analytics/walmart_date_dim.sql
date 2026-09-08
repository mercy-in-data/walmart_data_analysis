{{ config(
    materialized='table'
) }}

SELECT DISTINCT
    TO_NUMBER(TO_CHAR(store_date, 'YYYYMMDD')) AS Date_id,
    store_date AS Store_Date,
    CASE
        WHEN is_holiday THEN 'Yes'
        ELSE 'No'
    END AS IsHoliday,
    CURRENT_TIMESTAMP() AS Insert_date,
    CURRENT_TIMESTAMP() AS Update_date
FROM {{ ref('stg_department') }}