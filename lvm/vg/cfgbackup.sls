# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}
{% from "lvm/templates/macros.jinja" import getopts with context %}

{%- if lvm.vg and "cfgbackup" in lvm.vg and lvm.vg.cfgbackup is mapping %}

lvm_vg_cfgbackup_dir:
  file.directory:
    - name: {{ lvm.config.dir.backups }}
    - user: root
    - group: {{ lvm.group }}
    - dir_mode: {{ lvm.dir_mode }}
    - makedirs: True

  {%- for vg, vgdata in lvm.vg.cfgbackup.items() %}

lvm_vg_cfgbackup_{{ vg }}:
  cmd.run:
    - name: vgcfgbackup -f {{ lvm.config.dir.backups }}/{{ vgdata['file'] }} {{ getopts(vgdata) }} {{ vg }}
    - onlyif: vgdisplay {{ vg }} 2>/dev/null
    - require:
      - file: lvm_vg_cfgbackup_dir

  {%- endfor %}
{%- else %}

lvm_vg_cfgbackup_nothing_to_do:
  test.show_notification:
    - text: |
        No "vg.cfgbackup" pillar data supplied - nothing to do!

{%- endif %}
