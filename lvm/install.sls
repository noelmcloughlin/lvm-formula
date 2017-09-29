# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "lvm/map.jinja" import lvm_settings with context %}

lvm.pkg:
    pkg.installed:
        - name: {{ lvm_settings.pkg }}
