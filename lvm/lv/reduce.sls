# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}
{% from "lvm/files/macros.jinja" import getopts with context %}

{%- if lvm.lv and "reduce" in lvm.lv and lvm.lv.reduce is mapping %}
  {%- for lv, lvdata in lvm.lv.reduce.items() %}

lvm_lv_reduce_{{ lv }}:
  cmd.run:
    - name: lvreduce {{ getopts(lvdata) }} {{ lv }}
    - onlyif: lvdisplay {{ lv }}

  {%- endfor %}
{%- else %}

lvm_lv_reduce_nothing_to_do:
  test.show_notification:
    - text: |
        No "lv.reduce" pillar data supplied - nothing to do!           

{%- endif %}
