{{ config(
    materialized='incremental',
    unique_key='date_id',
    incremental_strategy='merge'
) }}

WITH source_data AS (

    SELECT DISTINCT
        TO_NUMBER(TO_CHAR(store_date, 'YYYYMMDD')) AS date_id,
        store_date,
        CASE
            WHEN is_holiday THEN 'Yes'
            ELSE 'No'
        END AS is_holiday

    FROM {{ ref('stg_department') }}

)

SELECT
    src.date_id,
    src.store_date,
    src.is_holiday,

    {% if is_incremental() %}
        tgt.insert_date,
    {% else %}
        CURRENT_TIMESTAMP() AS insert_date,
    {% endif %}

    CURRENT_TIMESTAMP() AS update_date

FROM source_data src

{% if is_incremental() %}

LEFT JOIN {{ this }} tgt
    ON src.date_id = tgt.date_id

WHERE tgt.date_id IS NULL
   OR src.store_date <> tgt.store_date
   OR src.is_holiday <> tgt.is_holiday

{% endif %}