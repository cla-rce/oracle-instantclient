#
# Author:: Joshua Buysse <buysse@umn.edu
# Cookbook Name:: chef_handlers
# Recipe:: campfire_handler
#
# Copyright 2011, Opscode, Inc.
# Copyright 2012, Regents of the Universiyt of Minnesota
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

# force resource actions in compile phase so exception handler 
# fires for compile phase exceptions

# required for the handler to function
# we need to force this to run at compile time
# see http://wiki.opscode.com/display/chef/Evaluate+and+Run+Resources+at+Compile+Time
gem_httparty = gem_package "httparty" do
  action :nothing
end
gem_httparty.run_action(:install)
Gem.clear_paths

chef_handler "CampfireHandler" do
  source "#{node['chef_handler']['handler_path']}/campfire_handler.rb"
  # this should come from attributes, user is borkborkbork (buysse@ugmail.com)
  # right now
  if node[:cla_unix_baseline][:use_system_proxy]
    arguments :subdomain => "universityofminnesota5", 
      :token => 'e7ad3accfb4d586457178088c272eb51a26d3005',
      :room_id => '455767',
      :use_system_proxy => true,
      :system_proxy => node[:cla_unix_baseline][:system_proxy]
  else
    arguments :subdomain => "universityofminnesota5", 
      :token => 'e7ad3accfb4d586457178088c272eb51a26d3005',
      :room_id => '455767'
  end
  action :enable
end

