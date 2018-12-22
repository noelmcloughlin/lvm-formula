# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}
{% from "lvm/templates/macros.jinja" import getopts with context %}

{%- if lvm.vg and lvm.vg.enable_cfgrestore and "cfgrestore" in lvm.vg and lvm.vg.cfgrestore is mapping %}

lvm_vg_cfgrestore_dir:
  file.directory:
    - name: {{ lvm.config.dir.backups }}
    - user: root
    - group: {{ lvm.group }}
    - dir_mode: {{ lvm.dir_mode }}
    - makedirs: True

  {%- for vg, vgdata in lvm.vg.cfgrestore.items() %}

lvm_vg_cfgrestore_{{ vg }}:
  cmd.run:
    - name: vgcfgrestore -f {{ lvm.config.dir.restores }}/{{ vgdata['file'] }} {{ getopts(vgdata) }} {{ vg }}
    - onlyif:
      - vgdisplay {{ vg }} 2>/dev/null
      - test -f {{ lvm.config.dir.restores }}/{{ vgdata['file'] }}
    - require:
      - file: lvm_vg_cfgrestore_dir

  {%- endfor %}
{%- else %}

lvm_vg_cfgrestore_nothing_to_do:
  test.show_notification:
    - text: |
        No "vg.cfgrestore" pillar data supplied (or 'enable_cfgrestore` is False) - nothing to do! 

{%- endif %}
