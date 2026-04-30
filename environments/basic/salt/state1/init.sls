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

{% if 'custom_grains' in pillar %}
/etc/salt/grains:
  file.managed:
    - source: salt://state1/files/grains.tmpl
    - template: jinja
    - context:
        custom_grains: {{ pillar.get('custom_grains', {}) | json }}
    - reload_grains: True

/tmp/grains:
  file.managed:
    - source: salt://state1/files/grains_out.tmpl
    - template: jinja
    - require:
      - file: /etc/salt/grains

reload_pillars:
  test.nop:
    - name: "Force pillar reload using the new grains"
    - reload_pillar: True
    - require:
      - file: /etc/salt/grains
{% endif %}
