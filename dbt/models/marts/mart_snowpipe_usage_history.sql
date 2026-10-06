{{
  config(
    materialized='table',
    cluster_by=['end_time'],
    tags=['snowflake_usage', 'mart']
  )
}}

-- Snowpipe usage history mart table
-- Provides historical usage data for Snowpipe including files processed and credits consumed

select
    pipe_id,
    pipe_name,
    start_time,
    end_time,
    credits_used,
    bytes_inserted,
    files_inserted,
    ingestion_time

from {{ ref('stg_snowpipe_usage_history') }}


