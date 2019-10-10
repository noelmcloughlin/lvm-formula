# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}
{% from "lvm/templates/macros.jinja" import getopts with context %}
{% from "lvm/templates/macros.jinja" import getlist with context %}

{%- if lvm.lv and "convert" in lvm.lv and lvm.lv.convert is mapping %}
  {%- for lv, lvdata in lvm.lv.convert.items() %}

lvm_lv_convert_{{ lv }}:
  cmd.run:
    - name: lvconvert --yes {{ getopts(lvdata) }} {{ lv }} {{ getlist(lvdata['devices']) if 'devices' in lvdata else '' }}
    - onlyif: lvdisplay {{ lv }} 2>/dev/null

  {%- endfor %}
{%- else %}

lvm_lv_convert_nothing_to_do:
  test.show_notification:
    - text: |
        No "lv.convert" pillar data supplied - nothing to do!

{%- endif %}
