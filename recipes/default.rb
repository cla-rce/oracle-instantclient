#
# Cookbook Name:: oracle-instantclient
# Recipe:: default
#
# Copyright 2011, Joshua Buysse, (C) Regents of the University of Minnesota
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

arch_flag = node["kernel"]["machine"] == "x86_64" ? ".x64" : ""
basic_file_name = "instantclient-basic-linux#{arch_flag}-#{node["oracle_instantclient"]["client_version"]}.zip"
tools_file_name = "instantclient-tools-linux#{arch_flag}-#{node["oracle_instantclient"]["client_version"]}.zip"
install_dir = node["oracle_instantclient"]["install_dir"]

case node["platform"]
when "ubuntu"
  package %w( unzip libaio1 )
when "redhat", "centos"
  package %w( unzip libaio )
end

directory "#{install_dir}/dist" do
  owner "root"
  group "root"
  mode "0755"
  recursive true
end

remote_file "#{install_dir}/dist/#{basic_file_name}" do
  source "#{node[:oracle_instantclient][:download_base]}/#{basic_file_name}"
  action :create_if_missing
  notifies :run, "execute[unpack_instant_client]", :immediately
end

execute "unpack_instant_client" do
  command "/usr/bin/unzip #{install_dir}/dist/#{basic_file_name} -d #{install_dir}"
  action :nothing
  notifies :run, "execute[run_ldconfig]"
end

remote_file "#{install_dir}/dist/#{tools_file_name}" do
  source "#{node["oracle_instantclient"]["download_base"]}/#{tools_file_name}"
  action :create_if_missing
  notifies :run, "execute[unpack_tools]", :immediately
  only_if { node["oracle_instantclient"]["client_version"].to_f >= 12.0 }
end

execute "unpack_tools" do
  command "/usr/bin/unzip #{install_dir}/dist/#{tools_file_name} -d #{install_dir}"
  action :nothing
  notifies :run, "execute[run_ldconfig]"
end

template "/etc/ld.so.conf.d/oracle_instantclient.conf" do 
  source "oracle_instantclient.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :run, "execute[run_ldconfig]"
end

template "/etc/profile.d/oracle_instantclient.csh" do 
  source "oracle_instantclient.csh.erb"
  owner "root"
  group "root"
  mode "0644"
end

template "/etc/profile.d/oracle_instantclient.sh" do 
  source "oracle_instantclient.sh.erb"
  owner "root"
  group "root"
  mode "0644"
end

link "libclntsh.so" do
  target_file "#{install_dir}/#{node["oracle_instantclient"]["client_dir_name"]}/libclntsh.so"
  to "libclntsh.so.#{node["oracle_instantclient"]["client_version"].split(".")[0]}.1"
end

execute "run_ldconfig" do 
  command "/sbin/ldconfig"
  action :nothing
end
