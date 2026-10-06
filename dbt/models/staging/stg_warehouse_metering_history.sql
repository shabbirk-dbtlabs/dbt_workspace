{{
  config(
    materialized='incremental',
    unique_key='start_time',
    on_schema_change='fail',
    cluster_by=['start_time'],
    tags=['snowflake_usage', 'incremental']
  )
}}

select
    start_time,
    end_time,
    warehouse_id,
    warehouse_name,
    credits_used,
    credits_used_compute,
    credits_used_cloud_services,
    current_timestamp() as ingestion_time

from {{ source('snowflake_account_usage', 'warehouse_metering_history') }}

{% if is_incremental() %}
  -- CDC logic: only load records newer than the latest end_time in our table
  where end_time > (select coalesce(max(end_time), '1970-01-01'::timestamp_ltz) from {{ this }})
{% endif %}


