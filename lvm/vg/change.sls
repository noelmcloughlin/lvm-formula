# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}
{% from "lvm/files/macros.jinja" import getopts with context %}

{%- if lvm.vg and "change" in lvm.vg and lvm.vg.change is mapping %}
  {%- for vg, vgdata in lvm.vg.change.items() %}

lvm_vg_change_{{ vg }}:
  cmd.run:
    - name: vgchange {{ getopts(vgdata) }} {{ vg }}
    - onlyif: vgdisplay {{ vg }}

  {%- endfor %}
{%- else %}

lvm_vg_change_nothing_to_do:
  test.show_notification:
    - text: |
        No "vg.change" pillar data supplied - nothing to do!           

{%- endif %}
