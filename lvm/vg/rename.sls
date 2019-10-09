# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}
{% from "lvm/templates/macros.jinja" import getopts with context %}

{%- if lvm.vg and "rename" in lvm.vg and lvm.vg.rename is mapping %}
  {%- for vg, vgdata in lvm.vg.rename.items() %}

lvm_vg_rename_{{ vg }}:
  cmd.run:
    - name: vgrename {{ getopts(vgdata) }} {{ vg }} {{ vgdata['newname'] }}
    - onlyif: vgdisplay {{ vg }} 2>/dev/null
    - unless: vgdisplay {{ vgdata['newname'] }} 2>/dev/null

  {%- endfor %}
{%- else %}

lvm_vg_rename_nothing_to_do:
  test.show_notification:
    - text: |
        No "vg.rename" pillar data supplied - nothing to do!

{%- endif %}
