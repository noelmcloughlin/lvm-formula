# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}

  {%- if "remove" in lvm.files and lvm.files.remove is iterable and lvm.files.remove is not string %}
    {% set loopdevs = salt['cmd.shell']('losetup -a | cut -d: -f1').split('\n') or [] %}
    {%- for file in lvm.files.remove %}

      {%- for loopdev in loopdevs %}
         {%- if loopdev %}
lvm file losetup delete {{ loopdev|lower }} if attached to {{ file }}:
  cmd.run:
    - name: losetup --detach {{ loopdev }}
    - onlyif: losetup -a | grep {{ loopdev }} | grep {{ file }}
         {%- endif %}
      {% endfor %}

lvm file remove {{ file }}:
  file.absent:
    - name: {{ file }}

    {% endfor %}
  {%- else %}

lvm_files_remove_nothing_to_do:
  test.show_notification:
    - text: |
        No "files.remove" pillar data supplied - nothing to do!

  {%- endif %}
