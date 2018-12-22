# -*- coding: utf-8 -*-
# vim: ft=sls

## Automate tasks in logical sequence ...

include:
    - lvm.lv.remove
    - lvm.vg.remove
    - lvm.pv.remove
    - lvm.profiles.remove
    - lvm.files.remove
