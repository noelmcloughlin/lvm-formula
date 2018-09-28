# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}
{% from "lvm/templates/macros.jinja" import getopts with context %}

{%- if lvm.pv and "create" in lvm.pv and lvm.pv.create is mapping %}
  {% for pv, pvdata in lvm.pv.create.items() if pv not in ('create', 'delete',) %}

lvm_pv_create_{{ pv }}:
  lvm.pv_present:
    - name: {{ pv }}
    - unless: pvdisplay {{ pv }}
    {{ getopts(pvdata, True) }}

  {%- endfor %}
{%- else %}

lvm_pv_create_nothing_to_do:
  test.show_notification:
    - text: |
        No "pv.create" pillar data supplied - nothing to do!          

{%- endif %}
