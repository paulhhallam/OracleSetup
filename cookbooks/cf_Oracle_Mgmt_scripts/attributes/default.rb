#
#  Production database names
#
default["oracle"]["prod"]["databases"] = ["a","c","e"]

#
#  Data Wharehouse / BI database names
#
default["oracle"]["dwh"]["databases"] = ["dwh","bi","stg"]

#
# Oracle home scripts directories
#
default["oracle"]["dbs"]["homescripts"] = [
"/home/oracle/scripts",
"/home/oracle/scripts/dba",
"/home/oracle/scripts/changerequests"]

#
#  Directories used by Cashflows for backups, scripts and logs
#
default["oracle"]["dbs"]["dirs"] = [
"/backup",
"/backup/oracle",
"/backup/oracle/backups",
"/backup/oracle/backups/rmanbackup",
"/backup/oracle/datapumps",
"/backup/oracle/exports",
"/backup/oracle/logs",
"/backup/oracle/logs/ADRCI",
"/backup/oracle/logs/ADUMP",
"/backup/oracle/logs/agent",
"/backup/oracle/logs/ALERT",
"/backup/oracle/logs/ALOG",
"/backup/oracle/logs/GG",
"/backup/oracle/logs/LSN",
"/backup/oracle/logs/monitorlogs",
"/backup/oracle/logs/rmanlogs",
"/backup/oracle/logs/SPpurge",
"/backup/oracle/logs/TSPACE",
"/backup/oracle/OGG",
"/u01",
"/u01/maint",
"/u01/maint/logs",
"/u01/maint/logs/rmanlogs",
"/u01/maint/scripts",
"/u01/maint/scripts/audit",
"/u01/maint/scripts/audit/splunk"]

#
#  Directories ** in the lists above ** that will have subdirectories of the database names
#
default["oracle"]["dbs"]["dbdirs"] = [
"/backup/oracle/OGG",
"/backup/oracle/backups/rmanbackup",
"/backup/oracle/datapumps",
"/backup/oracle/exports",
"/backup/oracle/logs/ADRCI",
"/backup/oracle/logs/ADUMP",
"/backup/oracle/logs/ALERT",
"/backup/oracle/logs/ALOG",
"/backup/oracle/logs",
"/backup/oracle/logs/GG",
"/backup/oracle/logs/LSN",
"/backup/oracle/logs/monitorlogs",
"/backup/oracle/logs/rmanlogs",
"/backup/oracle/logs/TSPACE",
"/u01/maint/logs/rmanlogs",
"/home/oracle/scripts/changerequests"]

#
# Directories that will have a directory name followed by a database name followed by a subdirectory name
#
default["oracle"]["dbs"]["dbsubdirs"] = ["parent"=>"/backup/oracle/backups/rmanbackup","subdir"=>"backupset"]

