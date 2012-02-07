#
# Cookbook Name:: cla_auth
# Recipe:: ad_rid
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

# generic for no OS
required_packages = []

# Check platform
case node[:platform]
when "ubuntu"
  if node[:platform_version].to_f != 10.04 then
    Chef::Log.fatal("Only implemented for Ubuntu Lucid/10.04")
    raise 
  end
  required_packages = %w{ winbind smbclient samba krb5-user }
when "redhat","centos"
  required_packages = %w{ samba3x samba3x-winbind tdb-tools krb5-workstation}
else
  Chef::Log.fatal("Only implemented for Ubuntu and RHEL variants")
  raise
end

# install the necessary packages
required_packages.each do |pkg|
  package pkg
end

# install the kerberos config

template "/etc/krb5.conf" do 
  source "krb5.conf.erb"
end

template "/etc/samba/smb.conf" do
  source "smb_ad_rid.conf.erb"
end

service "winbind" do 
  action :enable
end

# need to add code to join domain or test join, not done by default.  Needs a user password.


