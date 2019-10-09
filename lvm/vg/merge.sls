# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}
{% from "lvm/templates/macros.jinja" import getopts with context %}

{%- if lvm.vg and "merge" in lvm.vg and lvm.vg.merge is mapping %}
  {%- for vg, vgdata in lvm.vg.merge.items() %}

lvm_vg_merge_{{ vg }}:
  cmd.run:
    - name: vgmerge {{ getopts(vgdata) }} {{ vg }} {{ vgdata['withvg'] }}
    - onlyif: vgdisplay {{ vg }} 2>/dev/null && vgdisplay {{ vgdata['withvg'] }} 2>/dev/null

  {%- endfor %}
{%- else %}

lvm_vg_merge_nothing_to_do:
  test.show_notification:
    - text: |
        No "vg.merge" pillar data supplied - nothing to do!

{%- endif %}
