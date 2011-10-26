#
# Cookbook Name:: cla_unix_baseline
# Recipe:: system_proxy
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

# Check platform
case node[:platform]
when "ubuntu", "debian"
  # should work for all reasonably modern debian derivatives
  
  template "/etc/apt/apt.conf.d/99_cla_proxy" do 
    source "apt_proxy.erb"
  end

when "redhat", "centos"
  
  ### need to insert appropriate RHN config/yum config
  ### wgetrc might do it?

else
  Chef::Log.warn("proxy may not be fully implemented for platform")
end

template "/etc/wgetrc" do 
  source "wgetrc.erb"
end

template "/etc/profile.d/cla_proxy.sh" do
  source "cla_proxy.sh.erb"
end

template "/etc/profile.d/cla_proxy.csh" do
  source "cla_proxy.csh.erb"
end

