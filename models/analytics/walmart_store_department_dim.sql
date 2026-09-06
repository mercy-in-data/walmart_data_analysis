{{ config(
    materialized='incremental',
    unique_key=['store_id', 'dept_id'],
    incremental_strategy='merge'
) }}

WITH source_data AS (

    SELECT DISTINCT
        d.store_id,
        d.dept_id,
        s.store_type,
        s.store_size
    FROM {{ ref('stg_department') }} d
    JOIN {{ ref('stg_store') }} s
        ON d.store_id = s.store_id

)

SELECT
    src.store_id,
    src.dept_id,
    src.store_type,
    src.store_size,

    {% if is_incremental() %}
        tgt.insert_date,
    {% else %}
        CURRENT_TIMESTAMP() AS insert_date,
    {% endif %}

    CURRENT_TIMESTAMP() AS update_date

FROM source_data src

{% if is_incremental() %}

LEFT JOIN {{ this }} tgt
    ON src.store_id = tgt.store_id
    AND src.dept_id = tgt.dept_id

WHERE tgt.store_id IS NULL
   OR src.store_type <> tgt.store_type
   OR src.store_size <> tgt.store_size

{% endif %}