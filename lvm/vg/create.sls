# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}
{% from "lvm/templates/macros.jinja" import getopts with context %}

{%- if lvm.vg and "create" in lvm.vg and lvm.vg.create is mapping %}
  {% for vg, vgdata in lvm.vg.create.items() %}

lvm_vg_create_{{ vg }}:
  lvm.vg_present:
    - name: {{ vg }}
    - devices: {{ vgdata['devices']|json }}
    - unless:
      - vgdisplay {{ vg }} 2>/dev/null
      {%- for dev in vgdata['devices'] %}
        {# salt ignores True from multiple unless conditions? bug. #}
      - pvdisplay {{ dev }} 2>/dev/null | grep -i 'vg name.*[a-zA-Z1-9].*' 2>/dev/null
      {%- endfor %}
    {{ getopts(vgdata, True) }}

  {%- endfor %}
{%- else %}

lvm_vg_create_nothing_to_do:
  test.show_notification:
    - text: |
        No "vg.create" pillar data supplied - nothing to do!

{%- endif %}
