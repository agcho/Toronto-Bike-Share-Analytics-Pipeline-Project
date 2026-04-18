SELECT
    unique_row_id,
    filename AS file_name,
    Trip_Id AS trip_id,
    cast(Trip_Duration AS timestamp) AS trip_duration,
    Start_Station_Id AS start_station_id,
    cast(Start_Time AS timestamp) AS start_time,
    Start_Station_Name AS start_station_name,
    End_Station_Id AS end_station_id,
    cast(End_Time AS timestamp) AS end_time,
    End_Station_Name AS end_station_name,
    Bike_Id AS bike_id,
    User_Type AS user_type,
    Bike_Model AS bike_model
FROm {{ source("raw_data", "bikeshare_ridership") }}
WHERE trip_id is not null 
    AND start_time IS NOT NULL
    AND end_time IS NOT NULL
    AND end_time > start_time
QUALIFY ROW_NUMBER() OVER (PARTITION BY trip_id ORDER BY start_time) = 1