# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}
{% from "lvm/templates/macros.jinja" import getopts with context %}
{% from "lvm/templates/macros.jinja" import getlist with context %}

{%- if lvm.vg and "reduce" in lvm.vg and lvm.vg.reduce is mapping %}
  {%- for vg, vgdata in lvm.vg.reduce.items() %}

lvm_vg_reduce_{{ vg }}:
  cmd.run:
    - name: vgreduce {{ getopts(vgdata) }} {{ vg }} {{ getlist(vgdata['devices']) }}
    - onlyif: vgdisplay {{ vg }} 2>/dev/null

  {%- endfor %}
{%- else %}

lvm_vg_reduce_nothing_to_do:
  test.show_notification:
    - text: |
        No "vg.reduce" pillar data supplied - nothing to do!

{%- endif %}
