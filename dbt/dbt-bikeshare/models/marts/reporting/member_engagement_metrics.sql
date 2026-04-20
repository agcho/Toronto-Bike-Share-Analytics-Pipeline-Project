{{
  config(
    materialized='table',
    tags=['reporting', 'member_analytics'],
    description='Member engagement and activity metrics aggregated by user type'
  )
}}

SELECT 
    ut.user_type_id,
    ut.user_type_name,
    COUNT(DISTINCT f.trip_id) AS total_trips,
    COUNT(DISTINCT f.bike_id) AS unique_bikes_used,
    ROUND(AVG(COALESCE(f.trip_duration_minutes, 0)), 2) AS avg_trip_duration_minutes,
    ROUND(MIN(f.trip_duration_minutes), 2) AS min_trip_duration_minutes,
    ROUND(MAX(f.trip_duration_minutes), 2) AS max_trip_duration_minutes,
    ROUND(SUM(f.trip_duration_minutes), 2) AS total_trip_minutes,
    COUNT(DISTINCT DATE(f.start_time)) AS active_days,
    ROUND(COUNT(DISTINCT f.trip_id) / NULLIF(COUNT(DISTINCT DATE(f.start_time)), 0), 2) AS avg_trips_per_active_day,
    MIN(DATE(f.start_time)) AS first_trip_date,
    MAX(DATE(f.start_time)) AS last_trip_date,
    DATE_DIFF(MAX(DATE(f.start_time)), MIN(DATE(f.start_time)), DAY) AS days_since_first_trip
FROM {{ ref('fct_trips') }} f
LEFT JOIN {{ ref('dim_user_types') }} ut
    ON f.user_type_id = ut.user_type_id
WHERE ut.user_type_id IS NOT NULL
GROUP BY 
    ut.user_type_id,
    ut.user_type_name
ORDER BY total_trips DESC