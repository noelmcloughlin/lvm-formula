# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "lvm/map.jinja" import lvm_settings with context %}
{% from "lvm/map.jinja" import lvm with context %}

lvm packages installed:
  pkg.installed:
      {%- if "pkgs" in lvm %}
    - names: {{ lvm.pkgs }}
      {%- elif "pkg" in lvm %}
    - name: {{ lvm.pkg }}
      {%- elif "pkg" in lvm_settings %}
    - name: {{ lvm_settings.pkg }}
      {%- else %}
    - name: lvm2
      {% endif %}
