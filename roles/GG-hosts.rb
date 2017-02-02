#knife role from file GG-hosts.rb
#
name"GG-hosts"
description "Hosts running GoldenGate"
run_list "recipe[cf_Oracle_Mgmt_scripts::GoldenGate]"
