# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "lvm/map.jinja" import lvm_settings with context %}
{% from "lvm/map.jinja" import lvm with context %}

lvm packages:
  pkg.installed:
      {% if "pkgs" in lvm %}
    - names: {{ lvm.pkgs }}
      {% else %}
    - name: {{ lvm.pkg if "pkg" in lvm else lvm_settings.pkg }}
      {% endif %}
