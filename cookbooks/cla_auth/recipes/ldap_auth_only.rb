#
# Cookbook Name:: cla_auth
# Recipe:: ldap_auth_only
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

# ensure base packages needed to modify authentication are present.
include_recipe "cla_auth::default"

# Check platform
case node[:platform]
when "ubuntu"
  template "/etc/ldap.conf" do
    source "ubuntu-ldap-generic.conf.erb"
    notifies :run, "execute[nssldap-update-ignoreusers]"
    notifies :restart, "service[nscd]"
    notifies :run, "execute[cache-updated-ignoreusers]"
  end
  template "/etc/ldap/ldap.conf" do
    source "ubuntu-ldap-ldap-generic.conf.erb"
    #notifies :restart, "service[nscd]"
  end
  cookbook_file "/etc/ssl/certs/cla_auth_cacert.pem" do 
    source node[:cla_auth][:ldap_cacert_fname]
  end
  cookbook_file "/etc/auth-client-config/profile.d/cla-auth-ldaponly" do 
    source "cla-auth-ldaponly.profile"
  end
  execute "auth_client_conf_ldap_authonly" do 
    command "auth-client-config -p cla-auth-ldaponly -a"
    # don't do anything if we don't need to (we match profile now)
    not_if "auth-client-config -p cla-auth-ldaponly -a -s"
  end

  execute "nssldap-update-ignoreusers" do 
    # normally runs at boot, and it modifies /etc/ldap.conf to include
    # a list of local users (low uids) that should be ignored by nss
    # when deciding group membership.
    # without, sudo gets dodgy when ldap is down (very slow)
    command "/usr/sbin/nssldap-update-ignoreusers"
    action :nothing
  end
  execute "cache-updated-ignoreusers" do 
    # keep a copy of the updated ignoreusers list
    # not called from the update, so that we can ensure it's run after
    # checking for a change so we can restart nscd
    command "cp -p /etc/ldap.conf /etc/ldap.conf_after_ignoreusers"
    action :nothing
  end

  # this is a bit tricky
  service "nscd" do 
    # don't run if the file wasn't really changed after the template.
    # there's no real way to incorporate a full list of ignored users
    # in the template and have sudo work correctly if ldap is down
    not_if "diff /etc/ldap.conf /etc/ldap.conf_after_ignoreusers"
    action :nothing
  end

when "redhat", "centos"
  Chef::Log.warn("Only implemented for Ubuntu so far")
  service "nscd" do 
    action :nothing
  end

else
  Chef::Log.warn("Only implemented for Linux so far")
end

