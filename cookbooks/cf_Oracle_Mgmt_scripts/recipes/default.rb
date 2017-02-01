
#
# Create the Oracle home scripts directory structure
#
node["oracle"]["prod"]["homescripts"].each do |dirname|
  directory dirname do
    mode "0775"
    owner "oracle"
    group "oinstall"
  end
end

#
# Create the /u01/maint directory structure
#
node["oracle"]["prod"]["cashdirs"].each do |dirname|
  directory dirname do
    mode "0775"
    owner "oracle"
    group "oinstall"
  end
end

#
# Create the "database" named directories under the relevant directories
#
node["oracle"]["prod"]["cashdbdirs"].each do |dirname|
  node["oracle"]["prod"]["databases"].each do |subdir|
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
node["oracle"]["prod"]["cashdbsubdirs"].each do |data|
  node["oracle"]["prod"]["databases"].each do |dbdir|
    path_name="#{data["parent"]}/#{dbdir}/#{data["subdir"]}"
    directory path_name do
      mode "0775"
      owner "oracle"
      group "oinstall"
    end  
  end
end
#
# Restore all the /u01/maint/scripts shell and sql files
#
remote_directory "/u01/maint/scripts" do
  source 'maint/scripts'
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

file "/u01/maint/scripts/OGG_processchecks.sh" do
  content "maint/scripts/OGG_processchecks_#{node["hostname"]}.sh"
  owner 'oracle'
  group 'oinstall'
  mode '0775'
  action :create
end

file "/u01/maint/scripts/TSdatabasecheck.sh" do
  content "maint/scripts/TSdatabasecheck_#{node["hostname"]}.sh"
  owner 'oracle'
  group 'oinstall'
  mode '0775'
  action :create
end

file "/u01/maint/scripts/Housekeep_GoldenGateLogs" do
  content "maint/scripts/Housekeep_GoldenGateLogs_#{node["role"]}.sh"
  owner 'oracle'
  group 'oinstall'
  mode '0775'
  action :create
end

