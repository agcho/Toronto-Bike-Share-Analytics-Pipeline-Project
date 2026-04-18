SELECT 
    ut.user_type_name,
    ROUND(AVG(COALESCE(f.trip_duration_minutes, 0)), 2) AS avg_trip_duration_minutes
FROM {{ ref('fct_trips') }} f
LEFT JOIN {{ ref('dim_user_types') }} ut
    ON f.user_type_id = ut.user_type_id
GROUP BY ut.user_type_name