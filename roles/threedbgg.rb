#knife role from file threedbgg.rb
#
name"threedbgg"
description "Production accounts, central and endpoint databases running GoldenGate"
run_list "recipe[cf_Oracle_Mgmt_scripts::cf_prod_gg_scripts]"
