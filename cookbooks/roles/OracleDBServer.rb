#knife role from file OrcaleDBServer.rb
#
name"OracleDBServer"
description "Oracle DB Server"
run_list "recipe[cf_Oracle_Mgmt_scripts]"