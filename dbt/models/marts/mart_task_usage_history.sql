{{
  config(
    materialized='table',
    cluster_by=['scheduled_time'],
    tags=['snowflake_usage', 'mart']
  )
}}

-- Task usage history mart table
-- Provides historical execution data for tasks including run status and performance metrics

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
    ingestion_time

from {{ ref('stg_task_history') }}


