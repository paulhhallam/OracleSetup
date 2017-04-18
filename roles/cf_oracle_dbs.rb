#knife role from file cf_oracle_dbs.rb
#
name"cf_oracle_dbs"
description "Cashflows specific script and log directory setup for oracle databases"
run_list "role[SingleNodeDB], role[threedb], role[threedbgg]"
env_run_list "production" => ["recipe[cf::rec1]"], "dwh" => "recipe[cf::recdwh]"]
