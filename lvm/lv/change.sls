# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}
{% from "lvm/templates/macros.jinja" import getopts with context %}

{%- if lvm.lv and "change" in lvm.lv and lvm.lv.change is mapping %}
  {%- for lv, lvdata in lvm.lv.change.items() %}

lvm_lv_change_{{ lv }}:
  cmd.run:
    - name: lvchange {{ getopts(lvdata) }} {{ lv }}
    - onlyif: lvdisplay {{ lv }} 2>/dev/null

  {%- endfor %}
{%- else %}

lvm_lv_change_nothing_to_do:
  test.show_notification:
    - text: |
        No "lv.change" pillar data supplied - nothing to do!           

{%- endif %}
