{{
  config(
    materialized='table',
    cluster_by=['start_date'],
    tags=['snowflake_usage', 'mart', 'cost']
  )
}}

-- Snowflake cost mart table
-- Provides daily cost calculations based on warehouse credit consumption
-- Uses a rate of $3.00 per credit as in the original stored procedure

select
    start_time::date as start_date,
    sum(credits_used) as total_credits_used,
    sum(credits_used) * 3.00 as cost

from {{ ref('mart_warehouse_metering_history') }}

group by start_time::date

order by start_date desc


