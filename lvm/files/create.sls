# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}
{% from "lvm/templates/macros.jinja" import getopts, getoperands with context %}

{%- if "create" in lvm.files and lvm.files.create is mapping %}
  {%- if "truncate" in lvm.files.create and lvm.files.create.truncate is mapping %}
    {% for file, filedata in lvm.files.create.truncate.items() %}

##Shrink or extend the size of each FILE to the specified size
lvm file truncate {{ file }}:
  cmd.run:
    - cwd: {{ lvm.files.loopbackdir or '/tmp' }}
    - name: truncate {{- getopts(filedata) }} {{ file }}
    - unless: test -f {{ file }}

    {%- endfor %}
  {%- endif %}

  {%- if "dd" in lvm.files.create and lvm.files.create.dd is mapping %}
    {% for file, filedata in lvm.files.create.dd.items() %}

##Copy a file, converting and formatting according to the operands
lvm file dd {{ file }}:
  cmd.run:
    - cwd: {{ lvm.files.loopbackdir or '/tmp' }}
    - name: dd {{- getoperands(filedata) }} of={{ file }}
    - unless: test -f {{ file }}

    {%- endfor %}
  {%- endif %}

  {%- if "losetup" in lvm.files.create and lvm.files.create.losetup is mapping %}
    {% for file, filedata in lvm.files.create.losetup.items() %}

lvm file losetup {{ file }} as loopback device:
  cmd.run:
    - cwd: {{ lvm.files.loopbackdir or '/tmp' }}
    - name: losetup {{ getopts(filedata) or '--show --find' }}{{' '}}{{ file }}
    - onlyif: test -f {{ file }}

    {%- endfor %}
  {%- endif %}

{%- else %}

lvm_files_create_nothing_to_do:
  test.show_notification:
    - text: |
        No "files.create" pillar data supplied - nothing to do!

{%- endif %}
