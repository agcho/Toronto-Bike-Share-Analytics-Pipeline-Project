{#
    Macro: get_user_type
    Purpose: Generate user type dimension using Jinja dictionary
    Works across: BigQuery, Snowflake, DuckDB
#}

{% macro get_user_type() %}

{% set user_types = {
    1: 'Casual',
    2: 'Member'
} %}

{% for id, name in user_types.items() %}
select
    {{ id }} as user_type_id,
    '{{ name }}' as user_type_name
{% if not loop.last %}
union all
{% endif %}
{% endfor %}

{% endmacro %}