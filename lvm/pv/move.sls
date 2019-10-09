# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}
{% from "lvm/templates/macros.jinja" import getopts with context %}

{%- if lvm.pv and "move" in lvm.pv and lvm.pv.move is mapping %}
  {%- for pv, pvdata in lvm.pv.move.items() %}

lvm_pv_move_{{ pv }}:
  cmd.run:
    - name: pvmove --yes {{ getopts(pvdata) }} {{ pv }} {{ pvdata['dest'] }}
    - onlyif:
      - pvdisplay {{ pv }} 2>/dev/null
      - pvdisplay {{ pvdata['dest'] }} 2>/dev/null
      - pvdisplay {{ pvdata['dest'] }} 2>/dev/null | grep -i 'vg name[a-zA-Z1-9].*' 2>/dev/null

  {%- endfor %}
{%- else %}

lvm_pv_move_nothing_to_do:
  test.show_notification:
    - text: |
        No "pv.move" pillar data supplied - nothing to do!

{%- endif %}
