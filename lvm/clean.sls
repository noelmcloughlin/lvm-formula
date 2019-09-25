# -*- coding: utf-8 -*-
# vim: ft=sls

## Automate tasks in logical sequence ...

include:
    - lvm.lv.clean
    - lvm.vg.clean
    - lvm.pv.clean
    - lvm.profiles.clean
    - lvm.files.clean
