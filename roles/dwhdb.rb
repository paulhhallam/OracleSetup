#knife role from file dwhdb.rb
#
name"dwhdb"
description "create cashflows logs subdirectories for datawarehouse databases"
run_list "recipe[cf_Oracle_Mgmt_scripts::cf_dwh_gg_scripts]"
