{% load_yaml as values %}
{% include 'nested/values.sls' ignore missing %}
{% endload %}

{% set test = "def" %}

{% if values %}
rendered_list:
{% for key, value in values.list.items() %}
{% if test in value %}
  - {{ key }}
{% endif %}
{% endfor %}
{% endif %}

filename: /dev
