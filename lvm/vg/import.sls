# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}
{% from "lvm/files/macros.jinja" import getopts with context %}

{%- if lvm.vg and "import" in lvm.vg and lvm.vg.import is mapping %}
  {%- for vg, vgdata in lvm.vg.import.items() %}

lvm_vg_import_{{ vg }}:
  cmd.run:
    - name: vgimport {{ getopts(vgdata) }} {{ vg }}
    - onlyif: vgdisplay {{ vg }}

  {%- endfor %}
{%- else %}

lvm_vg_import_nothing_to_do:
  test.show_notification:
    - text: |
        No "vg.import" pillar data supplied - nothing to do!           

{%- endif %}
