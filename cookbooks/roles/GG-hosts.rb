#knife role from file OrcaleDBServer.rb
#
name"GG-hosts"
description "Hosts running GoldenGate"
run_list "recipe[GoldenGate]"
