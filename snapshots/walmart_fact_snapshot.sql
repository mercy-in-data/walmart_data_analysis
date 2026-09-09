{% snapshot walmart_fact_snapshot %}

{{
    config(
        strategy='check',
        unique_key=['store_id', 'dept_id', 'date_id'],
        check_cols=[
            'store_size',
            'store_weekly_sales',
            'fuel_price',
            'temperature',
            'unemployment',
            'cpi',
            'markdown1',
            'markdown2',
            'markdown3',
            'markdown4',
            'markdown5'
        ],
        schema='ANALYTICS'
    )
}}

WITH source_data AS (

    SELECT
        d.store_id,
        d.dept_id,
        dt.date_id,

        s.store_size,

        d.weekly_sales AS store_weekly_sales,

        f.fuel_price,
        f.temperature,
        f.unemployment,
        f.cpi,
        f.markdown1,
        f.markdown2,
        f.markdown3,
        f.markdown4,
        f.markdown5

    FROM {{ ref('stg_department') }} d

    JOIN {{ ref('stg_fact') }} f
        ON d.store_id = f.store_id
        AND d.store_date = f.store_date

    JOIN {{ ref('walmart_date_dim') }} dt
        ON d.store_date = dt.store_date

    JOIN {{ ref('stg_store') }} s
        ON d.store_id = s.store_id

)

SELECT
    source_data.store_id,
    source_data.dept_id,
    source_data.date_id,
    source_data.store_size,
    source_data.store_weekly_sales,
    source_data.fuel_price,
    source_data.temperature,
    source_data.unemployment,
    source_data.cpi,
    source_data.markdown1,
    source_data.markdown2,
    source_data.markdown3,
    source_data.markdown4,
    source_data.markdown5

FROM source_data

{% endsnapshot %}