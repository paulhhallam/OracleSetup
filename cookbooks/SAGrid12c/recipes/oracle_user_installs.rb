search(:groups, "*:*").each do |data|
  group data["id"] do
  end
end

search(:users, "*:*").each do |data|
  user data["id"] do
    comment data["comment"]
    home data["home"]
    shell data["shell"]
    password data["password"]
    group data["group"]
    system true
    manage_home true
  end
end

search(:groups, "*:*").each do |data|
  group data["id"] do
    members data["members"]
  end
end


