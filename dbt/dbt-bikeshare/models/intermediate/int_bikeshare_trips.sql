WITH user_type AS ( 
    {{get_user_type()}}
), bike_model AS (
    {{get_bike_model()}}
), cleaned_trips AS (
    SELECT
        
        unique_row_id,
        file_name,

        trip_id,
        trip_duration,

        start_station_id,
        start_station_name,
        start_time,

        end_station_id,
        end_station_name,
        end_time,

        bike_id,

        ut.user_type_id,
        user_type,

        bm.bike_model_id,
        bike_model

    FROM
        {{ ref('stg_bikeshare_data') }} sbd
        LEFT JOIN user_type ut ON LOWER(TRIM(ut.user_type_name)) = LOWER(TRIM(sbd.user_type))
        LEFT JOIN bike_model bm ON LOWER(TRIM(bm.bike_model_name)) = LOWER(TRIM(sbd.bike_model))
    WHERE sbd.start_station_id IS NOT NULL
)

-- Remove duplicate trips by keeping only latest record for each trip_id
SELECT * FROM cleaned_trips
QUALIFY row_number() OVER (PARTITION BY trip_id ORDER BY end_time DESC, file_name) = 1