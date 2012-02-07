#
# Cookbook Name:: cla_clamav
# Recipe:: default
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

include_recipe "perl::default"

if platform?("centos", "redhat", "fedora", "scientific", "suse")
  include_recipe "yum::epel"
end

package "clamav" do
  action :upgrade
end

package "clamav-db" do
  case node[:platform]
  when "centos","redhat","fedora","scientific","suse"
    package_name "clamav-db"
  when "debian","ubuntu"
    package_name "clamav-freshclam"
  end
  action :upgrade
end

directory "/usr/local/bin" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

template "/usr/local/bin/clamav_scan_local" do
  source "clamav_scan_local.erb"
  owner "root"
  group "root"
  mode "0711"
end

cron "clamav" do
  hour "2"
  minute "0"
  case node[:cla_clamav][:run_frequency]
  when :weekly
    weekday "0" 
  when :monthly
    # do in the first week
    weekday "0"
    day "1-7"
  when :quarterly
    weekday "0" 
    day "1-7"
    month "1,4,7,10"
  else
    # daily
  end
  mailto "#{node[:cla_clamav][:email_to]}"
  command "/usr/local/bin/clamav_scan_local"
end