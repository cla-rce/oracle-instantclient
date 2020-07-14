#
# Cookbook Name:: oracle-instantclient
# Recipe:: php
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

if !platform?("ubuntu")
  Chef::Log.error("oracle-instantclient::php is only implemented for Ubuntu")
  return
end

if node["platform_version"].to_f == 14.04
  conf_dir      = "/etc/php5"
  ext_conf_dir  = "/etc/php5/mods-available"
  extension_dir = "/usr/lib/php5/20121212"
  package %w( expect expect-dev )
elsif node["platform_version"].to_f == 16.04
  conf_dir      = "/etc/php/7.0"
  ext_conf_dir  = "/etc/php/7.0/mods-available"
  extension_dir = "/usr/lib/php/20151012"
else # Newer than 16.04
  conf_dir      = "/etc/php/7.2"
  ext_conf_dir  = "/etc/php/7.2/mods-available"
  extension_dir = "/usr/lib/php/20170718"
end

include_recipe "oracle-instantclient::sdk"

template "/var/tmp/install_pecl_oci8.exp" do
  source "install_pecl_oci8.exp.erb"
  owner "root"
  group "root"
  mode "0755"
end

template "#{ext_conf_dir}/oci8.ini" do
  source "oci8.ini.erb"
  owner "root"
  group "root"
  mode "0755"
  only_if { File.exist?(conf_dir) }
end

execute "build oci8 php module" do
  command "/usr/bin/expect /var/tmp/install_pecl_oci8.exp"
  only_if { File.exist?(extension_dir) }
  not_if { File.exist?("#{extension_dir}/oci8.so") }
end

execute "enable oci8 php module" do
  command "php5enmod oci8/20" if node["platform_version"].to_f == 14.04
  command "phpenmod oci8/20" if node["platform_version"].to_f >= 16.04
  only_if { File.exist?("#{ext_conf_dir}/oci8.ini") }
  not_if {
    File.symlink?("#{conf_dir}/apache2/conf.d/20-oci8.ini") ||
    File.symlink?("#{conf_dir}/cli/conf.d/20-oci8.ini") ||
    File.symlink?("#{conf_dir}/cgi/conf.d/20-oci8.ini") ||
    File.symlink?("#{conf_dir}/fpm/conf.d/20-oci8.ini")
  }
end
