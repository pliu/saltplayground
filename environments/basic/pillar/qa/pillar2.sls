{% include 'nested/values.sls' ignore missing %}

custom_grains:
  test_grain1: value1

{% if grains.get('test_grain1') == 'value1' %}
conditional_pillar: coolio
{% endif %}
