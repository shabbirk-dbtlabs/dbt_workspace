{{
  config(
    materialized='incremental',
    unique_key='id',
    on_schema_change='fail',
    cluster_by=['graph_version_created_on'],
    tags=['snowflake_usage', 'incremental']
  )
}}

select
    root_task_id,
    graph_version,
    graph_version_created_on,
    name,
    id,
    database_id,
    database_name,
    schema_id,
    schema_name,
    owner,
    comment,
    warehouse_name,
    schedule,
    predecessors,
    state,
    definition,
    condition_text,
    allow_overlapping_execution,
    error_integration,
    last_committed_on,
    last_suspended_on,
    current_timestamp() as ingestion_time

from {{ source('snowflake_account_usage', 'task_versions') }}

{% if is_incremental() %}
  -- CDC logic: only load records where graph_version_created_on is newer than our latest ingestion_time
  where graph_version_created_on > (select coalesce(max(ingestion_time), '1970-01-01'::timestamp_ltz) from {{ this }})
{% endif %}


