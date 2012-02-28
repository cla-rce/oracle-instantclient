#
# Cookbook Name:: cla_cacerts
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

package "openssl" do 
  action :install
end

if node[:platform] == "redhat" or node[:platform] == "centos"
  package "openssl-perl" do 
    action :install
  end
end

remote_directory node[:cla_cacerts][:cacert_dir] do
  source "cacerts"
  purge false
  overwrite true
  files_owner "root"
  files_group "root"
  files_backup 0
  notifies :run, "execute[/usr/bin/c_rehash]"
end


execute "/usr/bin/c_rehash" do 
  action :nothing
  supports :run
end
