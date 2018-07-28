# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}
{% from "lvm/files/macros.jinja" import getopts with context %}
{% from "lvm/files/macros.jinja" import getlist with context %}

{%- if lvm.vg and "split" in lvm.vg and lvm.vg.split is mapping %}
  {%- for vg, vgdata in lvm.vg.split.items() %}

lvm_vg_split_{{ vg }}:
  cmd.run:
    - name: vgsplit {{ getopts(vgdata) }} {{ vg }} {{ vgdata['newvg'] }} {{ getlist(vgdata['devices']) }}
    - onlyif: vgdisplay {{ vg }}
    - unless: vgdisplay {{ vgdata['newvg'] }}

  {%- endfor %}
{%- else %}

lvm_vg_split_nothing_to_do:
  test.show_notification:
    - text: |
        No "vg.split" pillar data supplied - nothing to do!           

{%- endif %}
