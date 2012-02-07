#
# Cookbook Name:: cla_unix_baseline
# Recipe:: mctfr_base
#
# Copyright 2012, Joshua Buysse, (C) Regents of the University of Minnesota
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

# Need to set up the automounter on the host.

ubuntu_lucid_plist = %w( autofs5 )

rh_5_plist = %w( autofs )

case node[:platform]
when "ubuntu"
  ubuntu_lucid_plist.each do |pkg|
    package pkg
  end
  
when "redhat", "centos" 
  rh_5_plist.each do |pkg|
    package pkg
  end
end


# install automounter configuration
cookbook_file "/etc/auto.master" do 
  source "auto.master.mctfr"
  notifies :restart, "service[autofs]"
end

cookbook_file "/etc/auto.home" do 
  source "auto.home.mctfr"
  notifies :restart, "service[autofs]"
end

cookbook_file "/etc/auto.shared" do 
  source "auto.shared.mctfr"
  notifies :restart, "service[autofs]"
end

# Set up the idmap daemon
cookbook_file "/etc/idmapd.conf" do 
  source "idmapd.conf.mctfr"
  notifies :restart, "service[idmapd]"
end

service "autofs" do 
  action [:enable, :start]
end

service "idmapd" do 
  case node[:platform]
  when "ubuntu"
    service_name "idmapd"
  when "redhat","centos"
    service_name "rpcidmapd"
  end
  action [:enable, :start]
end