# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}
{% from "lvm/templates/macros.jinja" import getopts with context %}

{%- if lvm.pv and "change" in lvm.pv and lvm.pv.change is mapping %}
  {%- for pv, pvdata in lvm.pv.change.items() %}

lvm_pv_change_{{ pv }}:
  cmd.run:
    - name: pvchange --yes {{ getopts(pvdata) }} {{ pv }}
    - onlyif:
      - pvdisplay {{ pv }} 2>/dev/null
      - pvdisplay {{ pv }} 2>/dev/null | grep -i 'vg name[a-zA-Z1-9].*' 2>/dev/null

  {%- endfor %}
{%- else %}

lvm_pv_change_nothing_to_do:
  test.show_notification:
    - text: |
        No "pv.change" pillar data supplied - nothing to do!           

{%- endif %}
