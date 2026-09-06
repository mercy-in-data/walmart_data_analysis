{{ config(
    materialized='incremental'
) }}

SELECT
    Store AS store_id,
    Type AS store_type,
    Size AS store_size,
    _ingested_at,
    _file_name
FROM {{ source('walmart_raw', 'STORE') }}

{% if is_incremental() %}

WHERE _ingested_at > (
    SELECT MAX(_ingested_at)
    FROM {{ this }}
)

{% endif %}