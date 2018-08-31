# -*- coding: utf-8 -*-
# vim: ft=sls
## LEGACY STATE (BACKWARDS COMPATIBLE) FUTURE TODO: REMOVE ##

{% from "lvm/map.jinja" import lvm_settings with context %}

{# Creation order: pv -> vg -> lv #}

{% if 'pv' in lvm_settings and lvm_settings.pv %}
{% for pv,pv_options in lvm_settings.pv.items() %}
{% if ( 'enabled' in pv_options and pv_options.enabled ) or 'enabled' not in pv_options %}

lvm.pv.create_{{ pv_options.device|default(pv) }}:
    lvm.pv_present:
        - name: {{ pv_options.device|default(pv) }}
    {% if 'options' in pv_options and pv_options.options %}
    {% for opt,value in pv_options.options.items() %}
        - {{ opt }}: {{ value }} 
    {% endfor %}
    {% endif %}

{% endif %}
{% endfor %}
{% endif %}

{% if 'vg' in lvm_settings and lvm_settings.vg %}
{% for vg,vg_options in lvm_settings.vg.items() %}
{% if ( 'enabled' in vg_options and vg_options.enabled ) or 'enabled' not in vg_options %}

lvm.vg.create_{{ vg_options.name|default(vg) }}:
    lvm.vg_present:
        - name: {{ vg_options.name|default(vg) }}
        - devices: {{ vg_options.devices }}
    {% if 'options' in vg_options and vg_options.options %}
    {% for opt,value in vg_options.options.items() %}
        - {{ opt }}: {{ value }} 
    {% endfor %}
    {% endif %}

{% endif %}
{% endfor %}
{% endif %}

{% if 'lv' in lvm_settings and lvm_settings.lv %}
{% for lv,lv_options in lvm_settings.lv.items() %}
{% if ( 'enabled' in lv_options and lv_options.enabled ) or 'enabled' not in lv_options %}

lvm.lv.create_{{ lv_options.name|default(lv) }}:
    lvm.lv_present:
        - name: {{ lv_options.name|default(lv) }}
        - vgname: {{ lv_options.vgname }}
    {% if 'options' in lv_options and lv_options.options %}
    {% for opt,value in lv_options.options.items() %}
        - {{ opt }}: {{ value }} 
    {% endfor %}
    {% endif %}

{% endif %}
{% endfor %}
{% endif %}


{# Deletion order: lv -> vg -> pv #}

{% if 'lv' in lvm_settings and lvm_settings.lv %}
{% for lv,lv_options in lvm_settings.lv.items() %}
{% if 'enabled' in lv_options and not lv_options.enabled %}

lvm.lv.remove_{{ lv_options.name|default(lv) }}:
    lvm.lv_absent:
        - name: {{ lv_options.name|default(lv) }}
        - vgname: {{ lv_options.vgname }}

{% endif %}
{% endfor %}
{% endif %}

{% if 'vg' in lvm_settings and lvm_settings.vg %}
{% for vg,vg_options in lvm_settings.vg.items() %}
{% if 'enabled' in vg_options and not vg_options.enabled %}

lvm.vg.remove_{{ vg_options.name|default(vg) }}:
    lvm.vg_absent:
        - name: {{ vg_options.name|default(vg) }}

{% endif %}
{% endfor %}
{% endif %}

{% if 'pv' in lvm_settings and lvm_settings.pv %}
{% for pv,pv_options in lvm_settings.pv.items() %}
{% if 'enabled' in pv_options and not pv_options.enabled %}

lvm.pv.remove_{{ pv_options.device|default(pv) }}:
    lvm.pv_absent:
        - name: {{ pv_options.device|default(pv) }}

{% endif %}
{% endfor %}
{% endif %}
