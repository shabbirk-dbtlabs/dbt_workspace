{{
  config(
    materialized='incremental',
    unique_key='pipe_id',
    on_schema_change='fail',
    cluster_by=['created'],
    tags=['snowflake_usage', 'incremental']
  )
}}

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
    current_timestamp() as ingestion_time

from {{ source('snowflake_account_usage', 'pipes') }}

{% if is_incremental() %}
  -- CDC logic: only load records where last_altered is newer than our latest created timestamp
  where last_altered > (select coalesce(max(created), '1970-01-01'::timestamp_ltz) from {{ this }})
{% endif %}


