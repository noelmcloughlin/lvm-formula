# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}
{% from "lvm/files/macros.jinja" import getopts with context %}

{%- if lvm.vg and lvm.vg.enable_export and "export" in lvm.vg and lvm.vg.export is mapping %}
  {%- for vg, vgdata in lvm.vg.export.items() %}

lvm_vg_export_{{ vg }}:
  cmd.run:
    - name: vgexport {{ getopts(vgdata) }} {{ vg }}
    - onlyif: vgdisplay {{ vg }}

  {%- endfor %}
{%- else %}

lvm_vg_export_nothing_to_do:
  test.show_notification:
    - text: |
        No "vg.export" pillar data supplied (or 'enable_export` is False) - nothing to do!           

{%- endif %}
