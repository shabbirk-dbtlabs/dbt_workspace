{{
  config(
    materialized='table',
    cluster_by=['created'],
    tags=['snowflake_usage', 'mart']
  )
}}

-- Snowpipes mart table
-- Provides information about all pipes with latest ingestion time and currency flags

with snowpipes_with_latest as (
  select
    *,
    max(ingestion_time) over () as latest_ingestion_time
  from {{ ref('stg_snowpipes') }}
)

select
    pipe_id,
    pipe_name,
    pipe_schema_id,
    pipe_schema,
    pipe_catalog_id,
    pipe_catalog,
    is_autoingest_enabled,
    notification_channel_name,
    pipe_owner,
    definition,
    created,
    last_altered,
    comment,
    deleted,
    ingestion_time,
    latest_ingestion_time,
    case 
      when ingestion_time = latest_ingestion_time then true 
      else false 
    end as is_latest

from snowpipes_with_latest


