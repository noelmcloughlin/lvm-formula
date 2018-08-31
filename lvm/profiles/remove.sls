# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}

{%- if "remove" in lvm.profiles and lvm.profiles.remove is mapping %}
  {% for profile in lvm.profiles.remove %}
    {% if profile and "profile" not in lvm.profiles.default %}

lvm_profiles_remove_{{ profile }}:
  file.absent:
    - name: {{ lvm.config.dir.profiles }}/{{ profile }}
    - onlyif: test -f {{ lvm.config.dir.profiles }}/{{ profile }}

    {% endif %}
  {% endfor %}
{%- else %}

lvm_profiles_remove_nothing_to_do:
  test.show_notification:
    - text: |
        No "profiles.remove" pillar data supplied - nothing to do!

{%- endif %}
