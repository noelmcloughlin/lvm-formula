# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}
{% from "lvm/templates/macros.jinja" import getopts with context %}

{%- if lvm.pv and "remove" in lvm.pv and lvm.pv.remove is mapping %}
  {%- for pv, pvdata in lvm.pv.remove.items() %}

lvm_pv_clean_{{ pv }}:
  cmd.run:
    - name: pvremove --yes {{ getopts(pvdata) }} {{ pv }}
    - onlyif: pvdisplay {{ pv }} 2>/dev/null

  {%- endfor %}
{%- else %}

lvm_pv_clean_nothing_to_do:
  test.show_notification:
    - text: |
        No "pv.remove" pillar data supplied - nothing to do!

{%- endif %}
