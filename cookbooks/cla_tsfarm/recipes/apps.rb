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

windows_package "PuTTY version 0.62" do
  source "c:/windows/sysnative/cmd.exe"
  options '/c "\\\\cla-util.ad.umn.edu\\apps$\\putty\\0.62\\install.bat"'
  installer_type :custom
  action :install
end

windows_package "WinSCP 4.3.7" do
  source "c:/windows/sysnative/cmd.exe"
  options '/c "\\\\cla-util.ad.umn.edu\\apps$\\winscp\\4.3.7\\install.bat"'
  installer_type :custom
  action :install
end

windows_package "TextPad 5" do
  source "c:/windows/sysnative/cmd.exe"
  options '/c "\\\\cla-util.ad.umn.edu\\apps$\\TextPad\\5.4.2\\install.bat"'
  installer_type :custom
  action :install
end

windows_package "7-Zip 9.20 (x64 edition)" do
  source "c:/windows/sysnative/cmd.exe"
  options '/c "\\\\cla-util.ad.umn.edu\\apps$\\7-zip\\9.20\\install.bat"'
  installer_type :custom
  action :install
end

windows_package "Mozilla Firefox 10.0.6 (x86 en-US)" do
  source "c:/windows/sysnative/cmd.exe"
  options '/c "\\\\cla-util.ad.umn.edu\\apps$\\firefox\\10.0.6esr\\install.bat"'
  installer_type :custom
  action :install
end

# This package includes both the plugin and the ActiveX control
windows_package "Adobe Flash Player 11 Plugin" do
  source "c:/windows/sysnative/cmd.exe"
  options '/c "\\\\cla-util.ad.umn.edu\\apps$\\adobe\\flash player\\11.3.300.268\\install.bat"'
  installer_type :custom
  action :install
end

windows_package "NX Client for Windows 3.5.0-7" do
  source "c:/windows/sysnative/cmd.exe"
  options '/c "\\\\cla-util.ad.umn.edu\\apps$\\NX Client\\3.5.0-7\\install.bat"'
  installer_type :custom
  action :install
end

windows_package "Adobe Reader X (10.1.3)" do
  source "c:/windows/sysnative/cmd.exe"
  options '/c "\\\\cla-util.ad.umn.edu\\apps$\\adobe\\reader\\10.1.3\\install.bat"'
  installer_type :custom
  action :install
end

windows_package "Stata 12" do
  source "c:/windows/sysnative/cmd.exe"
  options '/c "\\\\cla-util.ad.umn.edu\\apps$\\stata\\12\\install.bat"'
  installer_type :custom
  action :install
end

windows_package "IBM SPSS Statistics 20" do
  source "c:/windows/sysnative/cmd.exe"
  options '/c "\\\\cla-util.ad.umn.edu\\apps$\\spss\\20\\install.bat"'
  installer_type :custom
  action :install
end

windows_package "Wolfram Mathematica 8 (M-WIN-L 8.0.1 2063990)" do
  source "c:/windows/sysnative/cmd.exe"
  options '/c "\\\\cla-util.ad.umn.edu\\apps$\\Mathematica\\8.0.1\\install.bat"'
  installer_type :custom
  action :install
end

windows_package "MATLAB R2012a" do
  source "c:/windows/sysnative/cmd.exe"
  options '/c "\\\\cla-util.ad.umn.edu\\apps$\\Matlab\\R2012a\\install.bat"'
  installer_type :custom
  action :install
end
