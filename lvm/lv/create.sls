# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}
{% from "lvm/files/macros.jinja" import getopts with context %}
{% from "lvm/files/macros.jinja" import getlist with context %}

{%- if lvm.lv and "create" in lvm.lv and lvm.lv.create is mapping %}
  {% for lv, lvdata in lvm.lv.create.items() %}

    {%- if lvdata and 'snapshot' in lvdata and lvdata['snapshot'] == True %}
      {# workaround https://github.com/saltstack/salt/issues/48808 #}

lvm_lv_create_{{ lv }}:
  cmd.run:
    - name: lvcreate --yes {{- getopts(lvdata) }} --name {{ lvdata['vgname'] }}/{{ lv }} --snapshot {{ lvdata['sourcelv'] }} {{- getlist(lvdata['devices']) if 'devices' in lvdata else '' }}
    - unless: lvdisplay {{ lvdata['vgname'] }}/{{ lv }}
    - onlyif: lvdisplay {{ lvdata['vgname'] }}/{{ lvdata['sourcelv'] }}
    #force??

    {%- else %}

lvm_lv_create_{{ lv }}:
  lvm.lv_present:
    - name: {{ lv }}
    - vgname: {{ lvdata['vgname'] }}
    {{ '- devices: ' ~ lvdata['devices'] if 'devices' in lvdata else '' }}
    {{ '- size: ' ~ lvdata['size'] if 'size' in lvdata else '' }}
    {{ '- pv: ' ~ lvdata['pv'] if 'pv' in lvdata else '' }}
    {{ '- force: ' ~ lvdata['force'] if 'force' in lvdata else '' }}
    {{ '- thinvolume: ' ~ lvdata['thinvolume'] if 'thinvolume' in lvdata else '' }}
    {{ '- thinpool: ' ~ lvdata['thinpool'] if 'thinpool' in lvdata else '' }}
    {{ getopts(lvdata, True) }}

    {%- endif %}
    - unless: lvdisplay {{ lv }} || lvdisplay {{ lvdata['vgname'] }}/{{ lv }}
  {%- endfor %}
{%- else %}

lvm_lv_create_nothing_to_do:
  test.show_notification:
    - text: |
        No "lv.create" pillar data supplied - nothing to do!           

{%- endif %}
