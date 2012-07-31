#
# Cookbook Name:: cla_tsfarm
# Recipe:: apps
#
# Copyright 2012, Adam Mielke, (C) Regents of the University of Minnesota
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

windows_package "Mozilla Firefox 10.0.6 (x86 en-US)" do
  source '"\\\\cla-util.ad.umn.edu\\apps$\\firefox\\10.0.6esr\\install.bat"'
  action :install
end

windows_package "Stata 11" do
  source '"\\\\cla-util.ad.umn.edu\\apps$\\stata\\11\\install.bat"'
  action :install
end

windows_package "IBM SPSS Statistics 20" do
  source '"\\\\cla-util.ad.umn.edu\\apps$\\spss\\20\\install.bat"'
  action :install
end
