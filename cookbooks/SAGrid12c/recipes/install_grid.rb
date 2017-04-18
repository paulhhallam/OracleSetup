# Add the ASM disks
# Add the u01 volume
#   fdisk /dev/sdb
#      c
#      u
#      p
#      n
#      p
#
#
#      w
#   /sbin/mkfs.ext4 -L /u01 /dev/sdb1
#   mkdir /u01
#   mount /dev/sdb1 /u01
#   vi /etc/fstab
#      LABEL=/u01           /u01                 ext4    defaults        1 2
#
# Download the grid kit
#
# cd /backup/software
# cp /media/sf_Chef/V* .
#
## Unpack the grid kit
#
# unzip V46096-GRID-01_1of2.zip
# unzip V46096-GRID-01_2of2.zip
#
# usermod -a -G wheel grid
# usermod -a -G wheel oracle
# cd /backup/software/grid
# chown oracle:oinstall *
# ./runInstaller -silent -noconfig -responseFile <>
# ./runInstaller -silent -responseFile /backup/software/grid/grid_sudo.rsp
# grid.rsp
# oracle.install.responseFileVersion=/oracle/install/rspfmt_crsinstall_response_schema_v12.1.0
# ORACLE_HOSTNAME=cc
# INVENTORY_LOCATION=/u01/app/oraInventory
# SELECTED_LANGUAGES=en,en_GB
# oracle.install.option=HA_CONFIG
# ORACLE_BASE=/u01/app/grid
# ORACLE_HOME=/u01/app/grid/product/12.1.0/grid
# oracle.install.asm.OSDBA=asmdba
# oracle.install.asm.OSOPER=asmoper
# oracle.install.asm.OSASM=asmadmin
# oracle.install.asm.SYSASMPassword=changeme
# oracle.install.asm.diskGroup.name=DATA
# oracle.install.asm.diskGroup.redundancy=EXTERNAL
# oracle.install.asm.diskGroup.AUSize=1
# oracle.install.asm.diskGroup.disks=ORCL:DATA01
# oracle.install.asm.diskGroup.diskDiscoveryString=
# oracle.install.asm.monitorPassword=changeme
# oracle.install.asm.ClientDataFile=
# oracle.install.config.managementOption=NONE
# oracle.install.config.omsHost=
# oracle.install.config.omsPort=0
# oracle.install.config.emAdminUser=
# # 

[grid@cc grid]$ The installation of Oracle Grid Infrastructure 12c was successful.
Please check '/u01/app/oraInventory/logs/silentInstall2017-03-14_12-17-40PM.log' for more details.

As a root user, execute the following script(s):
	1. /u01/app/oraInventory/orainstRoot.sh
	2. /u01/app/grid/product/12.1.0/grid/root.sh


Run the script on the local node.

Successfully Setup Software.
As install user, execute the following script to complete the configuration.
	1. /u01/app/grid/product/12.1.0/grid/cfgtoollogs/configToolAllCommands RESPONSE_FILE=<response_file>

 	Note:
	1. This script must be run on the same host from where installer was run. 
	2. This script needs a small password properties file for configuration assistants that require passwords (refer to install guide documentation).


[grid@cc grid]$ 

#
