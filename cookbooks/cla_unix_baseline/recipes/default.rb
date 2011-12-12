#
# Cookbook Name:: cla_unix_baseline
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


# Check platform
case node[:platform]
when "ubuntu"
  # fix the default umask on Ubuntu
  execute "append_umask_session" do 
    # test moved to template for ldif to keep things rolling with appropriate deps.
    command "/bin/echo 'session	optional	pam_umask.so	usergroups' >> /etc/pam.d/common-session"
    not_if "/bin/grep pam_umask.so.*usergroups /etc/pam.d/common-session"
  end
  execute "append_umask_session_noninteractive" do 
    # test moved to template for ldif to keep things rolling with appropriate deps.
    command "/bin/echo 'session	optional	pam_umask.so	usergroups' >> /etc/pam.d/common-session-noninteractive"
    not_if "/bin/grep pam_umask.so.*usergroups /etc/pam.d/common-session-noninteractive"
  end

  # set up the package databases
  package "python-software-properties" do 
    action :upgrade
  end

  template "/etc/apt/sources.list.d/ubuntu-enable-partner.list" do 
    source "ubuntu-enable-partner.erb"
    mode "0644"
    owner "root"
    group "root"
    variables( 
      :distro_name => node[:lsb][:codename]
    )
    not_if "/usr/bin/test -f /etc/apt/sources.list.d/ubuntu-enable-partner.list"
  end

  script "enable_ppa" do
    interpreter "bash"
    user "root"
    cwd "/tmp"
    code <<-EOH
    /usr/bin/add-apt-repository #{node[:cla_unix_baseline][:base_ppa]}
    EOH
    not_if "/usr/bin/test -f /etc/apt/sources.list.d/buysse-umn-lucid.list"
  end

when "redhat", "centos"
  
  ### need to fill in:
  ## epel repository
  ## local repositories
  
end

include_recipe "cla_shell::default"
include_recipe "cla_unix_baseline::syslog_setup"
include_recipe "cla_unix_baseline::base_packages"
include_recipe "cla_unix_baseline::system_proxy"
