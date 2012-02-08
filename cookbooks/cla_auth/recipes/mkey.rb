#
# Cookbook Name:: cla_auth
# Recipe:: mkey
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

# ensure base packages needed to modify authentication are present.
include_recipe "cla_auth::default"

case node[:platform]
when "ubuntu"
  if node[:platform_version].to_f == 10.04 then
    required_packages = %w{ libpam-radius-auth auth-client-config }
  else
    Chef::Log.fatal("Only implemented for Ubuntu Lucid/10.04")
    raise 
  end
when "redhat","centos"
  # the pam_radius module is in EPEL
  include_recipe "yum::epel"
  required_pacakges = %w{ pam_radius }
else
  Chef::Log.fatal("Only implemented for Ubuntu")
  raise
end

required_packages.each do |pkg|
  package pkg
end

# do the pam configuration for RADIUS auth
# first, fill in the secrets

directory "/etc/raddb" do
  owner "root"
  group "root"
  mode "700"
  action :create 
end

template "/etc/raddb/server" do 
  source "raddb_server.erb"
  owner "root"
  group "root"
  mode "600"
  action :create
end


case node[:platform]
# Debian and derivatives may use alternate location for servers file
when "ubuntu", "debian" then
  template "/etc/pam_radius_auth.conf" do 
    source "raddb_server.erb"
    owner "root"
    group "root"
    mode "600"
    action :create
  end
end


# do the per-platform configuration; stuff that's repeated on everything outside this.
case node[:platform]
when "ubuntu"
  if node[:platform_version].to_f == 10.04 then
    template "/etc/auth-client-config/profile.d/cla-radius-config" do 
      source "cla-radius-config.erb"
      owner "root"
      group "root"
      mode "644" 
    end    
    # switch to this profile if not currently running
    script "enable_radius_profile" do
      interpreter "bash"
      user "root"
      cwd "/tmp"
      code <<-EOH
      /usr/sbin/auth-client-config -t pam-account,pam-auth -p cla-radius-config
      EOH
    end
  else
    Chef::Log.fatal("Only implemented for Ubuntu Lucid/10.04")
    raise 
  end
when "redhat","centos"
  ## authconfig doesn't support this scheme.  Have to set it up manually.
  ## start with authconfig to set up basic local auth and disable any 
  ## existing name service
  execute "authconfig_disable" do 
    command "/usr/bin/authconfig --disablesysnetauth --disablenis --disableldapauth --enableshadow --enablemd5 --updateall"
    not_if "/usr/bin/grep pam_radius /etc/pam.d/system-auth"
  end
  
  template "/etc/pam.d/system-auth" do 
    source "pam_system-auth_radius.rhel5"
    mode "0644"
    owner "root"
    group "root"
  end
  
else
  Chef::Log.fatal("Only implemented for Ubuntu")
  raise
end
