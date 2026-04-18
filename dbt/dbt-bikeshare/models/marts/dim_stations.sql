{{ config(
    materialized='incremental',
    unique_key='station_id',
    incremental_strategy='merge'
) 
}}

WITH unioned_stations AS (

    SELECT
        start_station_id AS station_id,
        start_station_name AS station_name
    FROM {{ ref('int_bikeshare_trips') }}
    WHERE start_station_id IS NOT NULL

    UNION ALL

    SELECT
        end_station_id AS station_id,
        end_station_name AS station_name
    FROM {{ ref('int_bikeshare_trips') }}
    WHERE end_station_id IS NOT NULL

),

deduped AS (
    SELECT
        station_id,
        station_name
    FROM unioned_stations
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY station_id
        ORDER BY station_name DESC NULLS LAST
    ) = 1

)

SELECT *
FROM deduped