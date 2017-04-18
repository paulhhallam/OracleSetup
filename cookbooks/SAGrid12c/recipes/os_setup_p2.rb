#
# The recipe os_setup_p1 would, hopefully, download and install the 
# basic system rpm's required by oracle.
#
# Ensure software directory exists
#
directory "/backup" do
  mode "0775"
  owner "oracle"
  group "oinstall"
end
directory "/backup/software" do
  mode "0777"
  owner "oracle"
  group "oinstall"
end
#
# Download oracle asm rpm's
#
cookbook_file "/backup/software/cvuqdisk-1.0.9-1.rpm" do
  source "cvuqdisk-1.0.9-1.rpm"
  owner "grid"
  group "oinstall"
  mode "0755"
end
cookbook_file "/backup/software/oracleasm-support-2.1.8-1.el6.x86_64.rpm" do
  source "oracleasm-support-2.1.8-1.el6.x86_64.rpm"
  owner "grid"
  group "oinstall"
  mode "0755"
end
cookbook_file "/backup/software/oracleasmlib-2.0.4-1.el6.x86_64.rpm" do
  source "oracleasmlib-2.0.4-1.el6.x86_64.rpm"
  owner "grid"
  group "oinstall"
  mode "0755"
end
#
# Install ASM binaries for RedHat 6
#
rpm_package "cvuqdisk" do
  source "/backup/software/cvuqdisk-1.0.9-1.rpm"
  action :install
end
#
rpm_package "asm-support" do
  source "/backup/software/oracleasm-support-2.1.8-1.el6.x86_64.rpm"
  action :install
end
#
rpm_package "asmlib" do
  source "/backup/software/oracleasmlib-2.0.4-1.el6.x86_64.rpm"
  action :install
end
#
# Disable IPTABLES
#
service 'iptables' do
  action [:disable, :stop]
end
#
# Disable SELINUX
#
cookbook_file "/etc/selinux/config" do
  source "selinux_config"
end
#
# Create oracle base directory
#
directory "/u01" do
  owner 'oracle'
  group 'oinstall'
  mode '0775'
  action :create
end
#
directory "/u01/app" do
  owner 'oracle'
  group 'oinstall'
  mode '0775'
  action :create
end
#
#
#
ruby_block "oracle_limits" do
  block do
    file = Chef::Util::FileEdit.new("/etc/security/limits.conf")
    file.insert_line_if_no_match("oracle soft nofile 1024", "oracle soft nofile 1024")
    file.insert_line_if_no_match("oracle hard nofile 65536", "oracle hard nofile 65536")
    file.insert_line_if_no_match("oracle soft nproc 2047", "oracle soft nproc 2047")
    file.insert_line_if_no_match("oracle hard nproc 16384", "oracle hard nproc 16384")
    file.insert_line_if_no_match("oracle soft stack 10240", "oracle soft stack 10240")
    file.insert_line_if_no_match("oracle hard stack 32768", "oracle hard stack 32768")
    file.insert_line_if_no_match("oracle hard memlock 37748736", "oracle hard memlock 37748736")
    file.insert_line_if_no_match("oracle soft memlock 37748736", "oracle soft memlock 37748736")
    file.insert_line_if_no_match("grid soft nofile 1024", "grid soft nofile 1024")
    file.insert_line_if_no_match("grid hard nofile 65536", "grid hard nofile 65536")
    file.insert_line_if_no_match("grid soft nproc 2047", "grid soft nproc 2047")
    file.insert_line_if_no_match("grid hard nproc 16384", "grid hard nproc 16384")
    file.insert_line_if_no_match("grid soft stack 10240", "grid soft stack 10240")
    file.insert_line_if_no_match("grid hard stack 32768", "grid hard stack 32768") 
    file.insert_line_if_no_match("grid soft memlock 37748736", "grid soft memlock 37748736")
    file.insert_line_if_no_match("grid hard memlock 37748736", "grid hard memlock 37748736")
    file.write_file
  end
end
#
# Configure ASM
#
bash 'OracleASM' do
  user 'root'
  code <<-EOF
  /etc/init.d/oracleasm configure << EOF2
  grid
  oinstall
  y
  y
  EOF2
EOF
end
#
# fdisk the ASM volume
#
## fdisk /dev/sdb
# n
# p
#
#
# w
##

#
# Mark the data disk
#
# /etc/init.d/oracleasm createdisk DATA01 /dev/sdb1
#

