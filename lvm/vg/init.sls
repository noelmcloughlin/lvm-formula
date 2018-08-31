# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "lvm/map.jinja" import lvm with context %}

## Automate tasks in logical sequence ...

include:
  - .cfgbackup
  - .import
  - .remove
  - .change
  - .reduce
  - .extend
  - .split
  - .merge
  - .rename
  - .create
  # following special UC are disabled by default
  - .export
  - .cfgrestore
