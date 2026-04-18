SELECT
    ss.station_name AS start_station_name,
    es.station_name AS end_station_name,

    COUNT(*) AS total_trips,

    ROUND(AVG(f.trip_duration_minutes), 2) AS avg_trip_duration_minutes,

    ROUND(SUM(f.trip_duration_minutes), 2) AS total_trip_minutes

FROM {{ ref('fct_trips') }} f
LEFT JOIN {{ ref('dim_stations')}} ss ON ss.station_id = f.start_station_id
LEFT JOIN {{ ref('dim_stations')}} es ON es.station_id = f.end_station_id

GROUP BY 
    start_station_name,
    end_station_name