{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}

        {{ default_schema }}

    {%- else -%}
        /* dbt by default adds an underscore _ after the target schema name before the custom_schema_name:

        target_custom_schema_name
        */
        {{ custom_schema_name | trim }}

    {%- endif -%}

{%- endmacro %}