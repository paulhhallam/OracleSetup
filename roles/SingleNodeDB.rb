#knife role from file SingleNodedb-hosts.rb
#
name"SingleNodeDB"
description "Hosts running Single Node Oracle database"
run_list "recipe[cf_Oracle_Mgmt_scripts::dbsdb]"
