{{
  config(
    materialized='table',
    cluster_by=['graph_version_created_on'],
    tags=['snowflake_usage', 'mart']
  )
}}

-- Tasks mart table
-- Provides information about task definitions with latest ingestion time and currency flags

with tasks_with_latest as (
  select
    *,
    max(ingestion_time) over () as latest_ingestion_time
  from {{ ref('stg_task_versions') }}
)

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
    ingestion_time,
    latest_ingestion_time,
    case 
      when ingestion_time = latest_ingestion_time then true 
      else false 
    end as is_latest

from tasks_with_latest


