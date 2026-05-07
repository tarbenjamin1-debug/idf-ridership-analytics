{% macro whoami() %}

  {{ log("WHOAMI step 1: use role TRANSFORM", info=True) }}
  {% do run_query("use role TRANSFORM") %}

  {{ log("WHOAMI step 2: use warehouse WH_DEV", info=True) }}
  {% do run_query("use warehouse WH_DEV") %}

  {{ log("WHOAMI step 3: use database IDF_TRANSPORT", info=True) }}
  {% do run_query("use database IDF_TRANSPORT") %}

  {{ log("WHOAMI step 4: use schema IDF_TRANSPORT.ANALYTICS", info=True) }}
  {% do run_query("use schema IDF_TRANSPORT.ANALYTICS") %}

  {{ log("WHOAMI step 5: select current context", info=True) }}
  {% set res = run_query("select current_user(), current_role(), current_database(), current_schema(), current_warehouse()") %}

  {% if execute %}
    {% set row = res.rows[0] %}
    {{ log("WHOAMI => user=" ~ row[0] ~ ", role=" ~ row[1] ~ ", db=" ~ row[2] ~ ", schema=" ~ row[3] ~ ", wh=" ~ row[4], info=True) }}
  {% endif %}

{% endmacro %}
