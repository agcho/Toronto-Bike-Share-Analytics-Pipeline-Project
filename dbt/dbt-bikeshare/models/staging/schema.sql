version: 2

models:
  - name: stg_bikeshare_data
    description: >
      Staging model for bikeshare data. This model standardizes column names
      and data types from the raw bikeshare source, providing a clean foundation
      for downstream transformations.
    columns:
          - name: unique_row_id
            description: unique identifier for each record
          - name: filename
            description: source file name for the record
          - name: trip_id
            description: unique identifier for each trip
          - name: trip_duration
            description: duration of the trip (stored as timestamp in current model)
          - name: start_station_id
            description: identifier of the station where the trip started
          - name: start_time
            description: timestamp when the trip started
          - name: start_station_name
            description: name of the station where the trip started
          - name: end_station_id
            description: identifier of the station where the trip ended
          - name: end_time
            description: timestamp when the trip ended
          - name: end_station_name
            description: name of the station where the trip ended
          - name: bike_id
            description: unique identifier of the bike used for the trip
          - name: user_type
            description: type of user (e.g., member, casual)
          - name: bike_model
            description: model of the bike used in the trip