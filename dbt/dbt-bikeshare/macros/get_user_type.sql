{#
    Macro to generate vendor lookup data using Jinja dictionary.

    This approach works seamlessly across BigQuery, DuckDB, Snowflake, etc.
    by generating UNION ALL statements at compile time.

    Returns: SQL that creates user type rows with user_type_id and user_type_name
#}

{% macro get_user_type() %}

{% set user_type = {
    1: 'Casual',
    2: 'Member'
} %}

{% for user_type_id, user_type_name in user_type.items() %}
    select {{ user_type_id }} as user_type_id, '{{ user_type_name }}' as user_type_name
    {% if not loop.last %}union all{% endif %}
{% endfor %}

{% endmacro %}