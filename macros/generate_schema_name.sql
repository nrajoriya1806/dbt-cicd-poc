{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}

    {% if target.name == 'prod' %}
        {# In production, use the custom schema directly #}
        {% if custom_schema_name is not none %}
            {{ custom_schema_name | trim }}
        {% else %}
            {{ default_schema }}
        {% endif %}
    {% elif env_var('DBT_CLOUD_PR_ID', '') != '' %}
        {# CI job: prefix with PR ID to isolate schemas #}
        dbt_cloud_pr_{{ env_var('DBT_CLOUD_PR_ID') }}_{{ custom_schema_name | default(default_schema, true) }}
    {% else %}
        {# Dev or other: use default schema with custom appended #}
        {% if custom_schema_name is not none %}
            {{ default_schema }}_{{ custom_schema_name | trim }}
        {% else %}
            {{ default_schema }}
        {% endif %}
    {% endif %}

{%- endmacro %}