#knife environmenmt list -w
#knife environment from file dwhdb.rb
#on node:
# vi /etc/chef/client.rb
#   ADD the line 
#  environment "dwhdb"
#

name "dwhdb"
description "Data Warehouse Oracle DB Servers"
cookbook "cf_Oracle_Mgmt_scripts", "= 0.1.0"

# override_attributes({
#   "author" => {
#            "name" => "phh"
#                     }
#}
#
#)
# In the attribute file this was default["author"]["name"] = "my name"
