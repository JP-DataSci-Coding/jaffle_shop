-- Macro takes two parameters, "custom_schema_name" and "node".
-- "nodes" refer to SQL files or entities like models, tests, seeds, snapshots etc.
{% macro generate_schema_name(custom_schema_name, node) -%}
    -- "set" is Jinja syntax for setting a variable
    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}

        {{ default_schema }}

    {%- else -%}
        /*
        The trim filter is often used. This trims leading and trailing whitespace from the string held in the <source_value>.

        Example usage: {{title|trim}}

        If the title field contained "   Project Manager   ", this would be converted to "Project Manager".
        */
        {{ custom_schema_name | trim }}

    {%- endif -%}

{%- endmacro %}