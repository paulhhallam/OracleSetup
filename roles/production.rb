#knife role from file production.rb
#
name"production"
description "Commanding role for creating cashflows specific scripts and directories"
run_list "role[SingleNodeDB], role[threedb], role[threedbgg]"
env_run_list "production" => ["recipe[cf::rec1]"], "dwh" => "recipe[cf::recdwh]"]
