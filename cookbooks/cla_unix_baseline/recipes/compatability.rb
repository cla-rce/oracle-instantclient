#
# Cookbook Name:: cla_unix_baseline
# Recipe:: compatibility
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

### ensure the correct chef gem is installed

# Check platform
case node[:platform]
when "ubuntu"
  nil
when "redhat", "centos"
  nil
end

# everywhere
### SRSLAB
link "/srslab" do 
  to "/labs/srslab/srslab.userfiles"
  type :symbolic
  action :create
end

### statistics
## preserve stats old HOME directory structure for user paths
directory "/HOME" do 
  owner "root"
  group "root"
  mode "0755"
  action :create
end
["faculty", "grads", "other", "staff"].each do |d| 
  link "/HOME/#{d}" do
    to "/home"
    type :symbolic
    action :create
  end
end

## preserve compat for old /APPS mount
link "/APPS" do 
  to "/pkg/stat-apps"
  type :symbolic
  action :create
end


