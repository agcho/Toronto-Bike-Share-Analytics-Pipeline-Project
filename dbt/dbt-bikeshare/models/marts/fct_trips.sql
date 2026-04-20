{{
  config(
    materialized='incremental',
    unique_key='trip_id',

    partition_by={
      "field": "start_time",
      "data_type": "timestamp",
      "granularity": "month"
    },

    on_schema_change='append_new_columns'
  )
}}

SELECT
    trip_id,
    TIMESTAMP_DIFF(end_time, start_time, SECOND) / 60 AS trip_duration_minutes,
    start_station_id,
    start_station_name,
    start_time,
    end_station_id,
    end_station_name,
    end_time,
    bike_id,
    bike_model_id,
    user_type_id
FROM {{ ref("int_bikeshare_trips") }}
WHERE start_station_id IS NOT NULL
    --AND end_station_id IS NOT NULL
{% if is_incremental() %}
    AND start_time > (
        SELECT MAX(start_time)
        FROM {{ this }}
    )
{% endif %}