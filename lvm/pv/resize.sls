# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}
{% from "lvm/templates/macros.jinja" import getopts with context %}

{%- if lvm.pv and "resize" in lvm.pv and lvm.pv.resize is mapping %}
  {%- for pv, pvdata in lvm.pv.resize.items() %}

lvm_pv_resize_{{ pv }}:
  cmd.run:
    - name: pvresize --yes {{ getopts(pvdata) }} {{ pv }}
    - onlyif: pvdisplay {{ pv }}

  {%- endfor %}
{%- else %}

lvm_pv_resize_nothing_to_do:
  test.show_notification:
    - text: |
        No "pv.resize" pillar data supplied - nothing to do!          

{%- endif %}
