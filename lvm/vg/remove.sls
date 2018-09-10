# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}
{% from "lvm/templates/macros.jinja" import getopts with context %}

{%- if lvm.vg and "remove" in lvm.vg and lvm.vg.remove is mapping %}
  {%- for vg, vgdata in lvm.vg.remove.items() %}

lvm_vg_remove_{{ vg }}:
  cmd.run:
    - name: vgremove --yes {{ getopts(vgdata) }} {{ vg }}
    - onlyif: vgdisplay {{ vg }}

  {%- endfor %}
{%- else %}

lvm_vg_remove_nothing_to_do:
  test.show_notification:
    - text: |
        No "vg.remove" pillar data supplied - nothing to do!           

{%- endif %}
