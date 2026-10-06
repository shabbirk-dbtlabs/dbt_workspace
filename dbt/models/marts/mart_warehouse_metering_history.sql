{{
  config(
    materialized='table',
    cluster_by=['start_time'],
    tags=['snowflake_usage', 'mart']
  )
}}

-- Warehouse metering history mart table
-- Provides historical warehouse usage data including credit consumption

select
    start_time,
    end_time,
    warehouse_id,
    warehouse_name,
    credits_used,
    credits_used_compute,
    credits_used_cloud_services,
    ingestion_time

from {{ ref('stg_warehouse_metering_history') }}


