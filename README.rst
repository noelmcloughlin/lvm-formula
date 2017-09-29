===========
lvm-formula
===========

Install and configure the LVM. Tested on CentOS 6/7 and Ubuntu 14/16.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

``lvm``
--------
Meta-state to join install and config states.

``install``
-----------
Install the lvm package.

``config``
----------
Configure PVs, VGs and LVs.
