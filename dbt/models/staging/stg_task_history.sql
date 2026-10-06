{{
  config(
    materialized='incremental',
    unique_key=['run_id', 'scheduled_time'],
    on_schema_change='fail',
    cluster_by=['scheduled_time'],
    tags=['snowflake_usage', 'incremental']
  )
}}

select
    name,
    query_text,
    condition_text,
    schema_name,
    task_schema_id,
    database_name,
    task_database_id,
    scheduled_time,
    completed_time,
    state,
    return_value,
    query_id,
    query_start_time,
    error_code,
    error_message,
    graph_version,
    run_id,
    root_task_id,
    scheduled_from,
    current_timestamp() as ingestion_time

from {{ source('snowflake_account_usage', 'task_history') }}

{% if is_incremental() %}
  -- CDC logic: only load records where ingestion_time is newer than our latest
  -- Note: using scheduled_time since original stored proc used ingestion_time for CDC
  where scheduled_time > (select coalesce(max(scheduled_time), '1970-01-01'::timestamp_ltz) from {{ this }})
{% endif %}


