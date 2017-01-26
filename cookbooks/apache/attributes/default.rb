default["apache"]["sites"]["vchefh1h.com"] = { "site_title" => "VCHEFH1H", "port" => 80, "domain" => "vchefh1h.com" }
default["apache"]["sites"]["vchefh2h.com"] = { "site_title" => "VCHEFH2H", "port" => 80, "domain" => "vchefh2h.com" }
default["author"]["name"] = "Paul H"
case node["platform"]
  when "oracle"
    default["apache"]["package"] = "httpd"
  when "centos"
    default["apache"]["package"] = "httpd"
  when "ubuntu"
    default["apache"]["package"] = "apache2"
end

