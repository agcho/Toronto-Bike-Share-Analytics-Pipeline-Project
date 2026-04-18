{{
  config(
    materialized='incremental',
    unique_key='trip_id',
    on_schema_change='fail'
  )
}}

WITH alltrips AS (
    SELECT * 
    FROM {{ ref("int_bikeshare_trips") }}
),

trips AS (
    SELECT
        t.trip_id,

        -- duration in minutes
        TIMESTAMP_DIFF(t.end_time, t.start_time, SECOND) / 60 AS trip_duration_minutes,

        -- stations
        st.station_id AS start_station_id,
        t.start_time,

        et.station_id AS end_station_id,
        t.end_time,

        t.bike_id,
        t.bike_model_id,
        t.user_type_id

    FROM alltrips t

    LEFT JOIN {{ ref("dim_stations") }} st
        ON st.station_id = t.start_station_id

    LEFT JOIN {{ ref("dim_stations") }} et
        ON et.station_id = t.end_station_id

    LEFT JOIN {{ ref("dim_bike_models") }} bm
        ON bm.bike_model_id = t.bike_model_id

    LEFT JOIN {{ ref("dim_user_types") }} ut
        ON ut.user_type_id = t.user_type_id
)

SELECT *
FROM trips

{% if is_incremental() %}
WHERE start_time >= (
    SELECT COALESCE(MAX(start_time), TIMESTAMP('1900-01-01'))
    FROM {{ this }}
)
{% endif %}