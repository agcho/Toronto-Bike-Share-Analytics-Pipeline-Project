# dbt-bikeshare

A dbt (data build tool) project for transforming raw Toronto Bike Share trip data into analytics-ready fact and dimension tables.

This project follows a **medallion architecture (staging → intermediate → marts)** and implements data quality testing, modular transformations, and scalable analytics modeling on BigQuery.

---

## Overview

This project models bike share data into a structured analytics warehouse to support reporting, dashboards, and behavioral analysis.

### Key Capabilities
- Data cleaning and standardization
- Business logic transformation
- Incremental fact table processing
- Dimensional modeling (star schema)
- Data quality testing with dbt
- BI-ready reporting models

---

### Prerequisites

- Python 3.10+
- dbt 1.5+
- Google Cloud Project with BigQuery access
- GCP service account credentials

---

## Project Structure

```
dbt-bikeshare/
├── analyses/                 # Ad-hoc analysis SQL files
├── macros/                   # Reusable Jinja macros
│   ├── get_bike_model.sql   # Bike model lookup generator
│   └── get_user_type.sql    # User type lookup generator
├── models/                   # dbt transformation models
│   ├── staging/              # Raw data staging layer
│   │   ├── sources.yml       # Source definitions and documentation
│   │   └── stg_bikeshare_data.sql
│   ├── intermediate/         # Intermediate transformation layer
│   │   └── int_bikeshare_trips.sql
│   └── marts/                # Analytics-ready fact/dimension tables
│       ├── schema.yml        # Mart table documentation
│       ├── dim_bike_models.sql
│       ├── dim_stations.sql
│       ├── dim_user_types.sql
│       ├── fct_trips.sql
│       └── reporting/        # Specialized reporting views
│           ├── member_engagement_metrics.sql
│           └── trip_flow_summary.sql
├── seeds/                    # Static lookup data (CSV)
├── snapshots/                # Slowly changing dimensions
├── tests/                    # Custom dbt tests
├── target/                   # Compiled SQL (generated)
├── dbt_project.yml          # Project configuration
└── profiles.yml             # Database connection (not in repo)

```

## Data Layers

### Staging
- Cleans and standardizes raw data
- Handles nulls and type casting
- Removes invalid records

**Model:** `stg_bikeshare_data`

---

### Intermediate
- Applies business logic
- Deduplicates trips (latest record wins)
- Enriches data with lookup IDs

**Model:** `int_bikeshare_trips`

---

### Marts

#### Fact Table
**fct_trips**
- One row per trip
- Trip duration in minutes
- User + bike + station references
- Incremental model (optimized for performance)

#### Dimensions
- `dim_stations`
- `dim_user_types`
- `dim_bike_models`

#### Reporting Models
- `member_engagement_metrics`
- `trip_flow_summary`

Used for BI dashboards and analysis.

---

## Key Analytics Use Cases

- Member vs casual rider behavior analysis
- Most popular station-to-station routes
- Trip duration and usage trends
- Bike utilization patterns
- Station demand analysis

---

## Performance Design

- Incremental fact table (`fct_trips`)
- Partitioned by `start_time`
- Clustered by `user_type_id`, `bike_model_id`
- Lean fact table design (no redundant attributes)

---

## Data Quality

Built-in dbt tests:
- `not_null`
- `unique`
- `relationships`
- `accepted_values`

Ensures data consistency and integrity across all layers.

---

## Running dbt

```bash
dbt run
dbt test
dbt build
