#
# For an oracle database server running the production databases, 
# at creation these are a, c and e but more could easily be added
# :
# This script will
#
# Create the "database" named directories under the relevant directories
#
node["oracle"]["dbs"]["dbdirs"].each do |dirname|
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
node["oracle"]["dbs"]["dbsubdirs"].each do |data|
  node["oracle"]["prod"]["databases"].each do |dbdir|
    path_name="#{data["parent"]}/#{dbdir}/#{data["subdir"]}"
    directory path_name do
      mode "0775"
      owner "oracle"
      group "oinstall"
    end  
  end
end


