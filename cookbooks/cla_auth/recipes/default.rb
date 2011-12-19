#
# Cookbook Name:: cla_auth
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

# ensure base packages needed to modify authentication are present.

# Check platform
case node[:platform]
when "ubuntu"
  packages = ['auth-client-config','ldap-auth-client']
  packages.each do |p|
    package p
  end
when "redhat", "centos"
  packages = ['authconfig']
  packages.each do |p|
    package p
  end
else
  Chef::Log.warn("Only implemented for Linux so far")
end
