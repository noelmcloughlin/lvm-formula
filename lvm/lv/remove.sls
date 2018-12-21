# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}
{% from "lvm/templates/macros.jinja" import getopts with context %}

{%- if lvm.lv and "remove" in lvm.lv and lvm.lv.remove is mapping %}
  {%- for lv, lvdata in lvm.lv.remove.items() %}

lvm_lv_remove_{{ lv }}:
  cmd.run:
    - name: lvremove --yes {{ getopts(lvdata) }} {{ lv }}
    - onlyif: lvdisplay {{ lv }} 2>/dev/null

  {%- endfor %}
{%- else %}

lvm_lv_remove_nothing_to_do:
  test.show_notification:
    - text: |
        No "lv.remove" pillar data supplied - nothing to do!           

{%- endif %}
