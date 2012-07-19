#
# Cookbook Name:: cla_unix_baseline
# Recipe:: syslog_setup
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

syslog_style = "none"
config_style = "modular"

# Check platform
case node[:platform]
when "ubuntu"
  syslog_style = "rsyslog"
  config_style = "modular"
  
when "redhat", "centos"
  if node[:platform_version].to_f < 6.0 then
    syslog_style = "traditional"
    config_style = "monolithic"
  else 
    syslog_style = "rsyslog"
    config_style = "monolithic"
  end
else
  Chef::Log.warn("Only implemented for Ubuntu and RHEL")
end

case syslog_style
when "traditional"
  template "/etc/syslog.conf" do
    source "syslog.conf.erb"
    mode "0644"
    owner "root"
    group "root"
    action :create
    notifies :restart, "service[syslog]"
  end
when "rsyslog"
  if "config_style" == "modular" then 
    template "/etc/rsyslog.conf" do 
      source "rsyslog-modular.erb"
      mode "0644"
      owner "root"
      group "root"
      action :create
      notifies :restart, "service[rsyslog]"
    end
    template "/etc/rsyslog.d/99-claoit.conf" do 
      source "rsyslog-config.erb"
      mode "0644"
      owner "root"
      group "root"
      action :create
      notifies :restart, "service[rsyslog]"
    end
    execute "remove_old_rsyslog_conf" do 
      only_if "test -f /etc/rsyslog.d/99-singularity.conf"
      command "rm /etc/rsyslog.d/99-singularity.conf"
      notifies :restart, "service[rsyslog]"
    end
  else # config_style is monolithic
    template "/etc/rsyslog.conf" do 
      source "rsyslog-monolithic.erb"
      mode "0644"
      owner "root"
      group "root"
      action :create
      notifies :restart, "service[rsyslog]"
    end
  end
end
  
  
service "syslog" do 
  supports :restart => true, :stop => true, :start => true
  action :nothing
end

service "rsyslog" do 
  supports :restart => true, :stop => true, :start => true
  action :nothing
end
