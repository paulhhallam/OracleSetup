#
# For an oracle database server running the Data Warehouse databases, 
# at creation these are dwh, bi and stg but more could easily be added
# :
# This script will
#
#
# Create the "database" named directories under the relevant directories
#
node["oracle"]["dbs"]["dbdirs"].each do |dirname|
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
node["oracle"]["dbs"]["dbsubdirs"].each do |data|
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
# Restore the relevant GoldenGate process check script
#
cookbook_file "/u01/maint/scripts/Housekeep_GoldenGateLogs.sh" do
  source "maint/GoldenGate/Housekeep_GoldenGateLogs_DWH.sh"
  owner 'oracle'
  group 'oinstall'
  mode '0775'
  action :create
end

