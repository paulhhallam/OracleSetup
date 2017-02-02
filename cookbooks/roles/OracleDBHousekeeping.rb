#knife role from file OrcaleDBHousekeeping.rb
#
name"OracleDBHousekeeping"
description "Oracle DB Housekeeping"
run_list "recipe[cf_Oracle_Mgmt_scripts]"
