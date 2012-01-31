#
# Cookbook Name:: cla_unix_baseline
# Recipe:: class_base_extensions
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


ubuntu_lucid_plist = %w{ logrotate nano cvs cvsps build-essential curl }

rh_5_plist = %w{ logrotate nano cvs curl }

case node[:platform]
when "ubuntu"
  ubuntu_lucid_plist.each do |pkg|
    package pkg
  end
  
  link "/usr/bin/pico" do 
    to "/usr/bin/nano" 
    not_if "test -f /usr/bin/pico"
  end
  
when "redhat", "centos" 
  Chef::Log.warn("CLASS base may not be fully implemented for platform")
  rh_5_plist.each do |pkg|
    package pkg
  end
end

# class users?  Need to refactor

include_recipe "class_git::default"

# in base
#include_recipe "postfix::default"

# sudo commands for managing class_tasks cron jobs
cla_sudo_commands "class_tasks" do
  allowed_group "classadm"
  target_user "class_tasks"
  commands [
    "/usr/bin/crontab *",
    "/bin/kill *",
    "/usr/bin/pkill *"
  ]
end
