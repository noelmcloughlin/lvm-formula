# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}
{% from "lvm/files/macros.jinja" import getopts with context %}

{%- if lvm.lv and "rename" in lvm.lv and lvm.lv.rename is mapping %}
  {%- for lv, lvdata in lvm.lv.rename.items() %}

lvm_lv_rename_{{ lv }}:
  cmd.run:
    - name: lvrename {{ getopts(lvdata) }} {{ lv }} {{ lvdata['vgname'] }}/{{ lvdata['newname'] }}
    - onlyif: lvdisplay {{ lv }}
    - unless: lvdisplay {{ lvdata['vgname'] }}/{{ lvdata['newname'] }}

  {%- endfor %}
{%- else %}

lvm_lv_rename_nothing_to_do:
  test.show_notification:
    - text: |
        No "lv.rename" pillar data supplied - nothing to do!           

{%- endif %}
