#
# Cookbook Name:: cla_users
# Recipe:: local_admins
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
gem_package "libshadow"

local_admin_group = Array.new

search(:local_admins, '*:*') do |u|
  local_admin_group << u['id']

  # ensure that base home directory exists
  directory "#{node[:cla_users][:local_admin_home]}" do 
    owner "root"
    group "root"
    mode "0711"
    recursive true
  end

  home_dir = "#{node[:cla_users][:local_admin_home]}/#{u['id']}"

  user u['id'] do
    uid u['uid']
    gid u['gid']
    shell u['shell']
    comment u['comment']
    supports :manage_home => true
    home home_dir
    if u['class'] == "system" then
      system true
    end
    if u['password_hash'] then 
      password u['password_hash']
    end
  end

  directory "#{home_dir}/.ssh" do
    owner u['id']
    group u['gid'] || u['id']
    mode "0700"
  end

  template "#{home_dir}/.ssh/authorized_keys" do
    source "authorized_keys.erb"
    owner u['id']
    group u['gid'] || u['id']
    mode "0600"
    variables :ssh_keys => u['ssh_keys']
  end
end

group "#{node[:cla_users][:local_admin_group]}" do
  gid node[:cla_users][:local_admin_group_gid]
  members local_admin_group
end
