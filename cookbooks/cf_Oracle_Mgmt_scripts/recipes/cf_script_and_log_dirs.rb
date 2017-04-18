#
# For an oracle database server we have certain script and log directories that will exist on all systems.
# :
# This script will
#   Create if necesssary the /home/oracle/scripts directory tree 
#   Create if necesssary the /u01/maint/scripts and /backup/oracle/logs directory tree 
#   Restore the /u01/maint/scripts housekeeping and maintenance shell and sql files
#   Restore the /home/oracle/scripts/dba shell and sql files
#   Restore the relevant tablespace check script - Because of password issues there are diufferent scripts for each host ?
#
#
# Create the Oracle home scripts directory structure
#
node["oracle"]["dbs"]["homescripts"].each do |dirname|
  directory dirname do
    mode "0775"
    owner "oracle"
    group "oinstall"
  end
end

#
# Create the /u01/maint and /backup/oracle/logs directory structure
#
node["oracle"]["dbs"]["dirs"].each do |dirname|
  directory dirname do
    mode "0775"
    owner "oracle"
    group "oinstall"
  end
end

#
# Restore the housekeeping and maintenance shell and sql files to /u01/maint/scripts 
#
remote_directory "/u01/maint/scripts" do
  source 'maint/HousekeepingAndOthers'
  files_mode '0775'
  files_owner 'oracle'
  files_group 'oinstall'
  owner 'oracle'
  group 'oinstall'
  mode '0775'
  action :create
end

#
# Restore the backup and archivelog cleanup scripts to /u01/maint/scripts
#
remote_directory "/u01/maint/scripts" do
  source 'maint/Backup'
  files_mode '0775'
  files_owner 'oracle'
  files_group 'oinstall'
  owner 'oracle'
  group 'oinstall'
  mode '0775'
  action :create
end

#
# Restore the /home/oracle/scripts/dba shell and sql files
#
remote_directory "/home/oracle/scripts/dba" do
  source 'home/scripts/dba'
  files_mode '0775'
  files_owner 'oracle'
  files_group 'oinstall'
  owner 'oracle'
  group 'oinstall'
  mode '0775'
  action :create
end

#
# Restore the relevant tablespace check script, identified by host name.
# Due to not yet sorting out single sign on each system has to have a seperate script.
#
cookbook_file "/u01/maint/scripts/TSdatabasecheck.sh" do
  source "maint/HousekeepingAndOthers/TSdatabasecheck_#{node["hostname"]}.sh"
  owner 'oracle'
  group 'oinstall'
  mode '0775'
  action :create
end


