
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
# Create the /u01/maint directory structure
#
node["oracle"]["dbs"]["cashdirs"].each do |dirname|
  directory dirname do
    mode "0775"
    owner "oracle"
    group "oinstall"
  end
end

#
# Create the "database" named directories under the relevant directories
#
node["oracle"]["dbs"]["cashdbdirs"].each do |dirname|
  node["oracle"]["dwh"]["databases"].each do |subdir|
    path_name = "#{dirname}/#{subdir}"
    directory path_name do
      mode "0775"
      owner "oracle"
      group "oinstall"
    end
  end
end

#
# Now create the subdirectories under the database names.
#
node["oracle"]["dbs"]["cashdbsubdirs"].each do |data|
  node["oracle"]["dwh"]["databases"].each do |dbdir|
    path_name="#{data["parent"]}/#{dbdir}/#{data["subdir"]}"
    directory path_name do
      mode "0775"
      owner "oracle"
      group "oinstall"
    end  
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
# Restore the relevant tablespace check script 
#
cookbook_file "/u01/maint/scripts/TSdatabasecheck.sh" do
  source "maint/HousekeepingAndOthers/TSdatabasecheck_#{node["hostname"]}.sh"
  owner 'oracle'
  group 'oinstall'
  mode '0775'
  action :create
end




