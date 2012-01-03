#
# Cookbook Name:: cla_torque
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

config_dir = "/tmp"  # should never hit this directory

case node[:platform]
when "ubuntu"
  package "torque-client"
  package "torque-mom"

  config_dir = "/var/spool/torque"

else
  Chef::Log.warn("Only implemented for Ubuntu Linux so far")
end #case platform

if node[:cla_torque][:server] then
  # we have a configured server, use it
  template "#{config_dir}/mom_priv/config" do 
    source "mom_config.erb"
    not_if "test \! -d #{config_dir}/mom_priv" 
    notifies :restart, "service[torque-mom]"
  end
  
  template "/etc/torque/server_name" do 
    not_if "test \! -d /etc/torque"
    source "server_name.erb"
    mode "0666"
    owner "root"
    group "root"
    notifies :restart, "service[torque-mom]"
  end
  
end
  
service "torque-mom" do 
  supports :restart => true
  action :nothing
end