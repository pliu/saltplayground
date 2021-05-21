{% set nvme_ssds = [] %}
{% for ssd in grains['SSDs'] %}
  {% if ssd.startswith('nvme') %}
    {% do nvme_ssds.append(ssd) %}
  {% endif %}
{% endfor %}

{% if nvme_ssds|length > 0 %}
  {% set cmd = 'cat /proc/mounts | grep ' + nvme_ssds[0] %}
  {% set ret = salt['cmd.shell'](cmd) %}
  {% if ret %}

/{{ nvme_ssds[0] }}:
  file.managed:
    - contents: |
        {{ ret | indent(8) }}
        {{ nvme_ssds | join(',') | indent(8) }}
        {{ salt['test_module.test_func']() }}

  {% endif %}
  {% set cmd = 'cat /proc/mounts | grep ' + nvme_ssds[0] + '[[:space:]]' %}
  {% if salt['cmd.shell'](cmd) %}

/never_touched:
  file.touch

  {% endif %}
{% endif %}
