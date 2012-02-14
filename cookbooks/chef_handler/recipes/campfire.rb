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
gem_package "httparty" do
  action :install
end

chef_handler "CampfireHandler" do
  source "#{node['chef_handler']['handler_path']}/campfire_handler.rb"
  # this should come from attributes, user is borkborkbork (buysse@ugmail.com)
  # right now
  arguments :subdomain => "universityofminnesota5", 
    :token => 'e7ad3accfb4d586457178088c272eb51a26d3005',
    :room_id => '455767'
  action :enable
end

