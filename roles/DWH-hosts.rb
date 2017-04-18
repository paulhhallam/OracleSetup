#knife role from file DWH-hosts.rb
#
name"DWH-hosts"
description "Hosts running DataWarehouse databases"
run_list "recipe[cf_Oracle_Mgmt_scripts::dwhdb]"
