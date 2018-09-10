# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}
{% from "lvm/templates/macros.jinja" import getopts with context %}
{% from "lvm/templates/macros.jinja" import getlist with context %}

{%- if lvm.vg and "extend" in lvm.vg and lvm.vg.extend is mapping %}
  {%- for vg, vgdata in lvm.vg.extend.items() %}

lvm_vg_extend_{{ vg }}:
  cmd.run:
    - name: vgextend {{ getopts(vgdata) }} {{ vg }} {{ getlist(vgdata['devices']) }}
    - onlyif: vgdisplay {{ vg }}

  {%- endfor %}
{%- else %}

lvm_vg_extend_nothing_to_do:
  test.show_notification:
    - text: |
        No "vg.extend" pillar data supplied - nothing to do!           

{%- endif %}
