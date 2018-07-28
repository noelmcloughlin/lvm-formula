# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}
{% from "lvm/files/macros.jinja" import getopts with context %}
{% from "lvm/files/macros.jinja" import getlist with context %}

{%- if lvm.lv and "extend" in lvm.lv and lvm.lv.extend is mapping %}
  {%- for lv, lvdata in lvm.lv.extend.items() %}

lvm_lv_extend_{{ lv }}:
  cmd.run:
    - name: lvextend {{ getopts(lvdata) }} {{ lv }} {{ getlist(lvdata['devices']) }}
    - onlyif: lvdisplay {{ lv }}

  {%- endfor %}
{%- else %}

lvm_lv_extend_nothing_to_do:
  test.show_notification:
    - text: |
        No "lv.extend" pillar data supplied - nothing to do!           

{%- endif %}
