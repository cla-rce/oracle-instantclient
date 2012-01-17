#
# Cookbook Name:: cla_db_mgmt
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

## dependencies
package "libaio1"


## installs the basic support structure
directory node[:cla_db_mgmt][:datadir] do
  owner "root"
  mode "0755"
end

directory node[:cla_db_mgmt][:logdir] do
  owner "root"
  mode "0755"
end

directory (node[:cla_db_mgmt][:home_base] || "/home") do
end  

["", "/etc", "/etc/instances", "/bin", "/share", "share/software_cache", "/share/software"].each do |aDir|
  directory "#{node[:cla_db_mgmt][:basedir]}/#{aDir}" do
    owner "root"
    mode "0755"
  end
end

template "#{node[:cla_db_mgmt][:basedir]}/bin/initialize_instance" do 
  source "initialize_instance.erb"
  mode "0755"
  owner "root"
end

template "#{node[:cla_db_mgmt][:basedir]}/bin/cron_runner" do 
  source "cron_runner.erb"
  mode "0755"
  owner "root"
end

# search for a list of database instances for this node

my_instances = search(:cla_db_mgmt_instances, "fqdn:#{node[:fqdn]}")

my_instances.each do |inst| 
  
  version_info = data_bag_item('cla_db_mgmt_versions', inst['full_db_version'])
  
  template "#{node[:cla_db_mgmt][:basedir]}/etc/instances/#{inst['id']}.my.conf" do 
    variables ( :instance => inst, :versioninfo => version_info )
    source "inst.my.conf.erb"
    mode "0644"
    owner "root"
  end

  template "#{node[:cla_db_mgmt][:basedir]}/etc/instances/#{inst['id']}.mysqld_tuning.conf" do 
    source "inst.mysqld_tuning.conf.erb"
    variables ( :instance => inst, :versioninfo => version_info )
    mode "0644"
    owner "root"
    # don't overwrite this once it's in place -- explicitly for per-instance tuning manually
    action :create_if_missing
  end

  # ensure the user exists
  user "#{inst['user']}" do
    home_base = node[:cla_db_mgmt][:home_base] || "/home"
    home "#{home_base}/#{inst['user']}"
    comment "Service user for cla_db_mgmt"
    supports :manage_home => true
    system true
    shell "/bin/bash"
    action [:create, :manage, :lock]
  end
  
  remote_file "#{node[:cla_db_mgmt][:basedir]}/share/software_cache/#{version_info['unpack_dir']}.tar.gz" do
    backup false
    owner "root"
    source version_info['download_url']
    #checksum version_info['checksum']
    action :create_if_missing
    notifies :run, "execute[unpack_db_version_#{inst['id']}]"
  end
  
  execute "unpack_db_version_#{inst['id']}" do
    cwd "#{node[:cla_db_mgmt][:basedir]}/share/software"
    command "tar xzf #{node[:cla_db_mgmt][:basedir]}/share/software_cache/#{version_info['unpack_dir']}.tar.gz"
    not_if "test -x #{node[:cla_db_mgmt][:basedir]}/share/software/#{version_info['unpack_dir']}/bin/mysqld"
    action :nothing
  end
  
  directory "#{node[:cla_db_mgmt][:datadir]}/#{inst['id']}" do
    mode "0710"
    owner inst[:user]
  end

  execute "makeinstance_#{inst['id']}" do
    command "#{node[:cla_db_mgmt][:basedir]}/bin/initialize_instance #{inst['id']}"
    environment ({ 'instance_user' => inst['user'],
                  'full_db_version' => inst['full_db_version'],
                  'db_unpack_dir' => version_info['unpack_dir'] })
    creates "#{node[:cla_db_mgmt][:datadir]}/#{inst['id']}/.initialized"
  end

  #template "#{node[:bluepill][:conf_dir]}/cla_db_mgmt_#{inst['id']}" do
  #  source "cla_db_mgmt_inst.pill.erb"
  #  mode "0755"
  #  owner "root"
  #end

  #bluepill_service "cla_db_mgmt_#{inst['id']}" do 
    #action [:load, :enable, :start]
  #end

end
