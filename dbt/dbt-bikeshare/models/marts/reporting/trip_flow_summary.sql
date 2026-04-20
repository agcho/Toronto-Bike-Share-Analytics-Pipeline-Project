{{
  config(
    materialized='table',
    tags=['reporting', 'flow_analysis'],
    description='Station-to-station trip flow analysis with traffic metrics'
  )
}}

WITH trip_routes AS (
    SELECT
        f.start_station_id,
        f.end_station_id,
        ss.station_name AS start_station_name,
        es.station_name AS end_station_name,
        COUNT(*) AS total_trips,
        ROUND(AVG(f.trip_duration_minutes), 2) AS avg_trip_duration_minutes,
        ROUND(SUM(f.trip_duration_minutes), 2) AS total_trip_minutes,
        MIN(f.start_time) AS earliest_trip,
        MAX(f.start_time) AS latest_trip,
        COUNT(DISTINCT DATE(f.start_time)) AS active_days
    FROM {{ ref('fct_trips') }} f
    LEFT JOIN {{ ref('dim_stations') }} ss 
        ON ss.station_id = f.start_station_id
    LEFT JOIN {{ ref('dim_stations') }} es 
        ON es.station_id = f.end_station_id
    WHERE f.start_station_id IS NOT NULL 
        AND f.end_station_id IS NOT NULL
    GROUP BY 
        f.start_station_id,
        f.end_station_id,
        ss.station_name,
        es.station_name
)

SELECT
    start_station_id,
    start_station_name,
    end_station_id,
    end_station_name,
    total_trips,
    ROUND(100.0 * total_trips / SUM(total_trips) OVER (), 2) AS pct_of_total_trips,
    ROW_NUMBER() OVER (ORDER BY total_trips DESC) AS route_rank,
    avg_trip_duration_minutes,
    total_trip_minutes,
    active_days,
    ROUND(total_trips / NULLIF(active_days, 0), 2) AS avg_trips_per_day,
    earliest_trip,
    latest_trip
FROM trip_routes
ORDER BY total_trips DESC