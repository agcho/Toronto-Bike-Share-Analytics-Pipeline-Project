{#
    Macro to generate vendor lookup data using Jinja dictionary.

    This approach works seamlessly across BigQuery, DuckDB, Snowflake, etc.
    by generating UNION ALL statements at compile time.

    Returns: SQL that creates bike model rows with bike_model_id and bike_model_name
#}

{% macro get_bike_model() %}

{% set bike_model = {
    1: 'EFIT',
    2: 'ICONIC'
} %}

{% for bike_model_id, bike_model_name in bike_model.items() %}
    select {{ bike_model_id }} as bike_model_id, '{{ bike_model_name }}' as bike_model_name
    {% if not loop.last %}union all{% endif %}
{% endfor %}

{% endmacro %}