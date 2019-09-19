===========
lvm-formula
===========

Linux logical volume management (LVM2) state API. 

note:: The `lvm.conf(5)` is indirectly managed via LVM profiles.

note:: See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available Meta states
======================

.. contents::
    :local:

``lvm``
--------
Meta-state to run all states in sequence: 'install', 'profiles', 'files', 'pv', 'vg', and 'lv'.

``lvm.profiles``
--------------
Meta-state to manage lvm profiles in sequence: 'remove', followed by 'create'.

``lvm.files``
-----------
Meta-state to run loopback file device states in sequence: 'remove', followed by 'create'. Included by `lvm.pv` state.

``lvm.pv``
-----------
Meta-state to run physical volume (PV) states in sequence: 'remove', 'change', 'resize', 'move', and finally 'create'.

``lvm.vg``
--------------
Meta-state to run all volume group states in sequence: 'cfgbackup', 'import', 'remove', 'change' 'reduce', 'extend', 'split', 'merge', 'rename', 'create', 'export' & 'cfgrestore'.

``lvm.lv``
-------------
Meta-state to run all logical volume states in sequence: Order 'remove', 'change', 'reduce', 'extend', 'rename', 'create', 'convert', and 'create' again.


Available substates
===================

.. contents::
    :local:

``lvm.remove``
------------
Remove lvm2 software.

``lvm.profiles.remove``
----------------------
Remove custom lvm profile(s)::

  profiles:
    remove:
      - sillyprofile

``lvm.install``
-----------
Install lvm2 package.

``lvm.config (depreciated)``
----------
Configure PVs, VGs and LVs using legacy pillar data (backwards compatibility only).

``lvm.remove``
------------
Remove lvm2 software.

``lvm.profiles.remove``
----------------------
Remove custom lvm profile(s)::

  profiles:
    remove:
      - sillyprofile

``lvm.profiles.create``
----------------------
Create custom lvm profile(s)::

  lvm:
    profiles:
      create:
        thin-generic-autoextend:
          activation:
            thin_pool_autoextend_threshold: 70
            thin_pool_autoextend_percent: 20


``lvm.files.remove``
------------------
Remove LVM backing files from the file system.

``lvm.files.create``
------------------
LVM Loopback HOW-TO support. Creates backing files (in /tmp by defaults) and loopback devices per pillars::

  lvm: 
    files:
      #loopbackdir: /tmp         #Where to create backing files? Default is /tmp anyway.
      remove:
        - /tmp/testfile1.img
        - /tmp/testfile2.img
      create:
        truncate:                #Shrink or extend the size of each FILE to the specified size
          testfile1.img:
            options:
              size: 100M
        dd:                      #copy a file, converting and formatting according to the operands
          testfile2.img:
            options:
              if: /dev/urandom
              bs: 1024
              count: 204800
        losetup:                 #set up and control loop devices
          testfile1.img:
          testfile2.img:
    pv:
      create:
        /dev/loop0:               #hopefully /tmp/testfile1.img (run 'sudo losetup -D' first for certainty)
        /dev/loop1:               #hopefully /tmp/testfile2.img (run 'sudo losetup -D' first for certainty)


``lvm.pv.remove``
--------------
Remove physical volumes (PVs)::

    remove:
      /dev/sdb:
        options:
          verbose: True
      /dev/sdc:
        options:
          debug: True
      /dev/sdd:
      /dev/sde:
      /dev/sdf:

``lvm.pv.change``
--------------
Change attributes of physical volume(s) (PVs)::

  pv:
    change:
      ##Named PV must belong to VG; i.e. PV must be allocatable
      /dev/sdd:
        options:
          addtag: 'goodpvs'
          deltag: 'badpvs'
          debug: 1

``lvm.pv.resize``
--------------
Resize disk(s) or partition(s) in use by LVM2::

  pv:
    resize:
      /dev/sdd:
        options:
          setphysicalvolumesize: 1G


``lvm.pv.move``
--------------
Move allocated physical extents (PEs) from Source PV to other PV(s)::

  pv:
    move:
      /dev/sdd:
        dest: /dev/sde
        options:
          name: vg00/lv1
          noudevsync: True

``lvm.pv.create``
--------------
Initialize disk(s) or partition(s) for use by LVM::

  pv:
    create:
      /dev/sdb:
      /dev/sdc:
      /dev/sdd:
      /dev/sde:
        options:
          override: True
          dataalignmentoffset: 7s
          metadatacopies: 1
          metadatasize: 40MiB
      /dev/sdf:
        options:
          metadatacopies: 1




``lvm.vg.cfgbackup``
-------------------
Backup the metadata of your volume groups::

  vg:
    cfgbackup:
      vg00:
        file: vg00_backup_today
        options:
          ignorelockingfailure: True
          readonly: True

``lvm.vg.import``
--------------
Make volume groups known to the system::

  vg:
    import:
      i_do_not_exist:
        options:
          verbose: True

``lvm.vg.remove``
--------------
Remove volume group(s)::

  vg:
    remove:
      vg00:
        options:
          noudevsync: True

``lvm.vg.change``
--------------
Change attributes of volume group(s)::

  vg:
    change:
      vg00:
        options:
          available: True
          syncronize: False
          addtag: 'goodvgs'
          deltag: 'badvgs'


``lvm.vg.reduce``
--------------
Remove one or more unused physical volumes from a volume group::

  vg:
    reduce:
      vg00:
        devices:
          - /dev/sdb
        options:
          removemissing: True

``lvm.vg.extend``
--------------
Add physical volumes to a volume group(s)::

  vg:
    extend:
      vg00:
        devices:
          - /dev/sdd
        options:
          restoremissing: True


``lvm.vg.split``
--------------
Split volume group(s) into two::

  vg:
    split:
      vg00:
        newvg: smallvg
        devices:
          - /dev/sdf
        options:
          clustered: n
          maxphysicalvolumes: 0
          maxlogicalvolumes: 0

``lvm.vg.merge``
--------------
Merge two volume groups::

  vg:
    merge:
      vg00:
        withvg: vg001

``lvm.vg.rename``
--------------
Rename volume group(s)::

  vg:
    rename:
      vg002:
        newname: vg002old

``lvm.vg.create``
--------------
Create volume group(s)::

  vg:
    create:
      vg00:
        devices:
          - /dev/sdb
          - /dev/sdc
        options:
          clustered: n
          maxlogicalvolumes: 0
          maxphysicalvolumes: 0
          physicalextentsize: 1024
      vg_large:
        devices:
          - /dev/sdd
          - /dev/sde
          - /dev/sdf

``lvm.vg.export``
--------------
Make volume groups unknown to the system::

  vg:
    export:
      vg_tmp:
        options:
          verbose: True
          commandprofile: command_profile_template

``lvm.vg.cfgrestore``
-------------------
Restore the metadata of VG(s) from text backup files produced by ``lvm.vg.cfgbackup`` state::

  vg:
    cfgrestore:
      vg00:
        file: vg00_backup_today
        options:
          debug: True




``lvm.lv.remove``
---------------
Remove LV(s)::

  lv:
    remove:
      lv_pool1:
        vgname: vg_large
      lv_pool1_meta:
        vgname: vg_large
      lvol0:
        vgname: vg_large
      lvol1:
        vgname: vg_large
      lvol2:
        vgname: vg_large
      lvol3:
        vgname: vg_large
      lvol4:
        vgname: vg_large
      lvol5:
        vgname: vg_large
      lvol6:
        vgname: vg_large
      my_raid1:
        vgname: vg_large
        options:
          force: True

``lvm.lv.change``
----------------
Change attributes of logical volume(s)::

  lv:
    change:
      vg00/lv1:
        options:
          permission: r
          activate: n
          addtag: 'goodlvs'
          deltag: 'badlvs'

``lvm.lv.reduce``
---------------
Reduce size of logical volume(s)::

  lv:
    reduce:
      vg00/lv1:
        options:
          extents: -2
      vg00/lv2:
        options:
          size: -20MiB

``lvm.lv.extend``
----------------
Extend size of logical volume(s)::

  lv:
    extend:
      vg00/lv1:
        options:
          #extents: +100%PVS
          extents: 2
        devices:
          - /dev/sdf

``lvm.lv.rename``
-------------
Rename LV(s)::

  lv:
    rename:
      vg00/lv1:
        vgname: vg00
        newname: lvolvo

``lvm.lv.create``
----------------
Create logical volume(s) in existing volume group(s)::

  lv:
    create:
      lv1:
        vgname: vg00
        size: 200MiB
        options:
          addtag: 'Coolvolume'
          contiguous: y
          monitor: y
      lv_stripe1:
        vgname: vg00
        size: 100MiB
        options:
          stripes: 2
          stripesize: 4096
      #On-demand snapshots, workaround: https://github.com/saltstack/salt/issues/48808
      sparse:
        vgname: vg00
        snapshot: True
        sourcelv: lv1
        size: '+10%ORIGIN'
        options:
          virtualsize: 200MiB
      lv2_snap:
        vgname: vg00
        snapshot: True
        sourcelv: lv2
        size: '+10%ORIGIN'

Note:: Thin provisioning needs two `create` states to run (`create`, `convert`, and `create`).


``lvm.lv.convert``
----------------
Change LV type and other utilities::

  lv:
    convert:
      ##thin pool logical volume
      vg_large/lv_thinpool1:
        options:
          type: thin-pool
          ##data and metadata LVs in a thin pool are best created on separate physical devices
          poolmetadata:
            - lv_pool1_meta
            - lv_pool1
      vg_large/lv_1:
        options:
          mirrors: 1
          mirrorlog: core
        devices:
          - /dev/sdd:0-15
          - /dev/sdd:0-15
      vg_large/lv_mirror1:
        options:
          splitmirrors: 1
          name: lv_split
          regionsize: 512KB
          background: False
          interval: 10

Note:: Thin provisioning needs two `create` states to run (`create`, `convert`, and `create`).


Todo
=======
- global filter support is important
- test some advanced LV/RAID scenarios
- file systems mngt

Good Pillar data
=================
Bad conf(5)iguration causes problems. Sanity check pillar data when troubleshooting "``unable to``" state failures.

OS families
=================
All Linux distributions supported.

