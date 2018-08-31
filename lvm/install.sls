# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "lvm/map.jinja" import lvm_settings with context %}
{% from "lvm/map.jinja" import lvm with context %}

lvm.pkg:
    pkg.installed:
        - name: {{ lvm_settings.pkg or (lvm.pkg if "pkg" in lvm else "lvm2") }}
