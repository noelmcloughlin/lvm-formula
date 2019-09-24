.. _readme:

lvm-formula
===========

|img_travis| |img_sr|

.. |img_travis| image:: https://travis-ci.com/saltstack-formulas/lvm-formula.svg?branch=master
   :alt: Travis CI Build Status
   :scale: 100%
   :target: https://travis-ci.com/saltstack-formulas/lvm-formula
.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release

Linux logical volume management (LVM2) state API. 

note:: The `lvm.conf(5)` is indirectly managed via LVM profiles.

.. contents:: **Table of Contents**
   :depth: 1

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

Todo
^^^^
- global filter support is important
- test some advanced LV/RAID scenarios
- file systems mngt

Good pillar data
^^^^^^^^^^^^^^^^
Bad configuration causes problems. Sanity check pillar data when troubleshooting "``unable to``" state failures.

OS families
^^^^^^^^^^^
All Linux distributions supported.

Contributing to this repo
-------------------------

**Commit message formatting is significant!!**

Please see :ref:`How to contribute <CONTRIBUTING>` for more details.

Available Meta states
---------------------

.. contents::
    :local:

``lvm``
^^^^^^^
Meta-state to run all states in sequence: 'install', 'profiles', 'files', 'pv', 'vg', and 'lv'.

``lvm.profiles``
^^^^^^^^^^^^^^^^
Meta-state to manage lvm profiles in sequence: 'remove', followed by 'create'.

``lvm.files``
^^^^^^^^^^^^^
Meta-state to run loopback file device states in sequence: 'remove', followed by 'create'. Included by `lvm.pv` state.

``lvm.pv``
^^^^^^^^^^
Meta-state to run physical volume (PV) states in sequence: 'remove', 'change', 'resize', 'move', and finally 'create'.

``lvm.vg``
^^^^^^^^^^
Meta-state to run all volume group states in sequence: 'cfgbackup', 'import', 'remove', 'change' 'reduce', 'extend', 'split', 'merge', 'rename', 'create', 'export' & 'cfgrestore'.

``lvm.lv``
^^^^^^^^^^
Meta-state to run all logical volume states in sequence: Order 'remove', 'change', 'reduce', 'extend', 'rename', 'create', 'convert', and 'create' again.

``lvm.clean``
^^^^^^^^^^^^^
Meta-state to run all clean states provided by this formula.


Available substates
-------------------

.. contents::
    :local:

``lvm.install``
^^^^^^^^^^^^^^^
Install lvm2 package.

``lvm.profiles.clean``
^^^^^^^^^^^^^^^^^^^^^^
Remove custom lvm profile(s)::

  profiles:
    remove:
      - sillyprofile

``lvm.profiles.create``
^^^^^^^^^^^^^^^^^^^^^^^
Create custom lvm profile(s)::

  lvm:
    profiles:
      create:
        thin-generic-autoextend:
          activation:
            thin_pool_autoextend_threshold: 70
            thin_pool_autoextend_percent: 20


``lvm.files.clean``
^^^^^^^^^^^^^^^^^^^
Remove LVM backing files from the file system.

``lvm.files.create``
^^^^^^^^^^^^^^^^^^^^
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


``lvm.pv.clean``
^^^^^^^^^^^^^^^^
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
^^^^^^^^^^^^^^^^^
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
^^^^^^^^^^^^^^^^^
Resize disk(s) or partition(s) in use by LVM2::

  pv:
    resize:
      /dev/sdd:
        options:
          setphysicalvolumesize: 1G


``lvm.pv.move``
^^^^^^^^^^^^^^^
Move allocated physical extents (PEs) from Source PV to other PV(s)::

  pv:
    move:
      /dev/sdd:
        dest: /dev/sde
        options:
          name: vg00/lv1
          noudevsync: True

``lvm.pv.create``
^^^^^^^^^^^^^^^^^
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
^^^^^^^^^^^^^^^^^^^^
Backup the metadata of your volume groups::

  vg:
    cfgbackup:
      vg00:
        file: vg00_backup_today
        options:
          ignorelockingfailure: True
          readonly: True

``lvm.vg.import``
^^^^^^^^^^^^^^^^^
Make volume groups known to the system::

  vg:
    import:
      i_do_not_exist:
        options:
          verbose: True

``lvm.vg.clean``
^^^^^^^^^^^^^^^^
Remove volume group(s)::

  vg:
    remove:
      vg00:
        options:
          noudevsync: True

``lvm.vg.change``
^^^^^^^^^^^^^^^^^
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
^^^^^^^^^^^^^^^^^
Remove one or more unused physical volumes from a volume group::

  vg:
    reduce:
      vg00:
        devices:
          - /dev/sdb
        options:
          removemissing: True

``lvm.vg.extend``
^^^^^^^^^^^^^^^^^
Add physical volumes to a volume group(s)::

  vg:
    extend:
      vg00:
        devices:
          - /dev/sdd
        options:
          restoremissing: True


``lvm.vg.split``
^^^^^^^^^^^^^^^^
Split volume group(s) into two::

  vg:
    split:
      vg00:
        newvg: smallvg
        devices:
          - /dev/sdf
        options:
          shared: n
          maxphysicalvolumes: 0
          maxlogicalvolumes: 0

``lvm.vg.merge``
^^^^^^^^^^^^^^^^
Merge two volume groups::

  vg:
    merge:
      vg00:
        withvg: vg001

``lvm.vg.rename``
^^^^^^^^^^^^^^^^^
Rename volume group(s)::

  vg:
    rename:
      vg002:
        newname: vg002old

``lvm.vg.create``
^^^^^^^^^^^^^^^^^
Create volume group(s)::

  vg:
    create:
      vg00:
        devices:
          - /dev/sdb
          - /dev/sdc
        options:
          shared: n
          maxlogicalvolumes: 0
          maxphysicalvolumes: 0
          physicalextentsize: 1024
      vg_large:
        devices:
          - /dev/sdd
          - /dev/sde
          - /dev/sdf

``lvm.vg.export``
^^^^^^^^^^^^^^^^^
Make volume groups unknown to the system::

  vg:
    export:
      vg_tmp:
        options:
          verbose: True
          commandprofile: command_profile_template

``lvm.vg.cfgrestore``
^^^^^^^^^^^^^^^^^^^^^
Restore the metadata of VG(s) from text backup files produced by ``lvm.vg.cfgbackup`` state::

  vg:
    cfgrestore:
      vg00:
        file: vg00_backup_today
        options:
          debug: True




``lvm.lv.clean``
^^^^^^^^^^^^^^^^
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
^^^^^^^^^^^^^^^^^
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
^^^^^^^^^^^^^^^^^
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
^^^^^^^^^^^^^^^^^
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
^^^^^^^^^^^^^^^^^
Rename LV(s)::

  lv:
    rename:
      vg00/lv1:
        vgname: vg00
        newname: lvolvo

``lvm.lv.create``
^^^^^^^^^^^^^^^^^
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
^^^^^^^^^^^^^^^^^^
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


Testing
-------

.. contents::
    :local:

Linux testing is done with ``kitchen-salt``.

Requirements
^^^^^^^^^^^^

* Ruby
* Docker

.. code-block:: bash

   $ gem install bundler
   $ bundle install
   $ bin/kitchen test [platform]

Where ``[platform]`` is the platform name defined in ``kitchen.yml``,
e.g. ``debian-9-2019-2-py3``.

``bin/kitchen converge``
^^^^^^^^^^^^^^^^^^^^^^^^

Creates the docker instance and runs the ``lvm`` main state, ready for testing.

``bin/kitchen verify``
^^^^^^^^^^^^^^^^^^^^^^

Runs the ``inspec`` tests on the actual instance.

``bin/kitchen destroy``
^^^^^^^^^^^^^^^^^^^^^^^

Removes the docker instance.

``bin/kitchen test``
^^^^^^^^^^^^^^^^^^^^

Runs all of the stages above in one go: i.e. ``destroy`` + ``converge`` + ``verify`` + ``destroy``.

``bin/kitchen login``
^^^^^^^^^^^^^^^^^^^^^

Gives you SSH access to the instance for manual testing.
