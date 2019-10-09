# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}

{%- if "create" in lvm.profiles and lvm.profiles.create is mapping %}

lvm_vg_profiles_dir:
  file.directory:
    - name: {{ lvm.config.dir.profiles }}
    - user: root
    - group: {{ lvm.group }}
    - dir_mode: {{ lvm.dir_mode }}
    - makedirs: True

  {%- for profile in lvm.profiles.create %}

lvm_profiles_create_{{ profile }}:
  file.managed:
    - name: {{ lvm.config.dir.profiles }}/{{ profile }}.profile
    - source: {{ lvm.cfgsource }}
    - template: jinja
    - user: root
    - group: {{ lvm.group }}
    - mode: {{ lvm.filemode }}
    - makedirs: True
    - context:
      data: {{ lvm.profiles.create[profile]|json }}
      format: {{ lvm.profiles.man5.format }}
    - require:
      - file: lvm_vg_profiles_dir

  {%- endfor %}
{%- else %}

lvm_profiles_create_nothing_to_do:
  test.show_notification:
    - text: |
        No "profiles.create" pillar data supplied - nothing to do!

{%- endif %}
