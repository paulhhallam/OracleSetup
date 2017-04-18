#knife role from file threedb.rb
#
name"threedb"
description "Create logs subdirectories for accounts, central and endpoint databases"
run_list "recipe[cf_Oracle_Mgmt_scripts::cf_prod_db_subdirs]"
