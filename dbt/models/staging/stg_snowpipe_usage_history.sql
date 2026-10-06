{{
  config(
    materialized='incremental',
    unique_key=['pipe_id', 'start_time'],
    on_schema_change='fail',
    cluster_by=['end_time'],
    tags=['snowflake_usage', 'incremental']
  )
}}

select
    pipe_id,
    pipe_name,
    start_time,
    end_time,
    credits_used,
    bytes_inserted,
    files_inserted,
    current_timestamp() as ingestion_time

from {{ source('snowflake_account_usage', 'pipe_usage_history') }}

{% if is_incremental() %}
  -- CDC logic: only load records newer than the latest end_time in our table
  where end_time > (select coalesce(max(end_time), '1970-01-01'::timestamp_ltz) from {{ this }})
{% endif %}


