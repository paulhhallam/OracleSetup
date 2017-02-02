
#
# Restore the relevant GoldenGate scripts to /u01/maint/scripts
#
remote_directory "/u01/maint/scripts" do
  source 'maint/GoldenGate'
  files_mode '0775'
  files_owner 'oracle'
  files_group 'oinstall'
  owner 'oracle'
  group 'oinstall'
  mode '0775'
  action :create
end

#
# Restore the relevant GoldenGate process check script
#
cookbook_file "/u01/maint/scripts/OGG_processchecks.sh" do
  source "maint/GoldenGate/OGG_processchecks_#{node["hostname"]}.sh"
  owner 'oracle'
  group 'oinstall'
  mode '0775'
  action :create
end


