{{ pillar['filename'] }}:
  file.touch

{% if 'rendered_list' in pillar and pillar['rendered_list'] %}
/rendered_list:
  file.managed:
    - contents: |
{%- for item in pillar['rendered_list'] %}
        {{ item }}
{% endfor %}
{% endif %}

{% if 'merge_dict' in pillar %}
{% for key, value in pillar['merge_dict'].items() %}
/{{ key }}:
  file.managed:
    - contents: |
        {{ value }}
{% endfor %}
{% endif %}

/etc/salt/grains:
  file.managed:
    - source: salt://state1/files/grains.tmpl
    - template: jinja

