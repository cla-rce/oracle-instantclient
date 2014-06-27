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

# installs from remote files
# requires the default recipe

include_recipe "oracle-instantclient::sdk"

if node[:kernel][:machine] == "x86_64" then
  arch_flag = ".x64"
else
  arch_flag = ""
end

# we need expect to build the pecl module
pkg_list = value_for_platform(
    ["centos","redhat","fedora", "scientific"] =>
        {"default" => %w{ expect expect-devel }},
    [ "debian", "ubuntu" ] =>
        {"default" => %w{ expect expect-dev }},
    "default" => %w{ expect expect-dev }
  )

pkg_list.each do |pkg| 
  package pkg
end

template "/var/tmp/install_pecl_oci8.exp" do
  source "install_pecl_oci8.exp.erb"
  mode "0755"
  owner "root"
end

php_conf_dir = value_for_platform(
  ["centos","redhat","fedora", "scientific"] => 
    {"default" => "/etc/php.d"},
  "ubuntu" => {
    "14.04" => "/etc/php5/mods-available",
    "default" => "/etc/php5/conf.d"
  },
  "default" => "/etc/php5/conf.d"
)

template "#{php_conf_dir}/oci8.ini" do 
  source "oci8.ini.erb"
  mode "0755"
end

php_lib_dir = value_for_platform(
  ["centos","redhat","fedora", "scientific"] => 
    {"default" => "/usr/lib/php/modules"},
  "ubuntu" => {
    "14.04" => "/usr/lib/php5/20121212",
    "default" => "/usr/lib/php5/20090626",
  },
  "default" => "/usr/lib/php5/20090626"
)

execute "build_php_oci8_mod" do
  command "/usr/bin/expect /var/tmp/install_pecl_oci8.exp"
  not_if "test -f #{php_lib_dir}/oci8.so"
end

execute "enable_oci8_mod" do
  command "php5enmod oci8/20"
  only_if { File.exist?("/etc/php5/mods-available/oci8.ini") }
  not_if do
    File.symlink?("/etc/php5/apache2/conf.d/20-oci8.ini") ||
    File.symlink?("/etc/php5/cli/conf.d/20-oci8.ini") ||
    File.symlink?("/etc/php5/cgi/conf.d/20-oci8.ini") ||
    File.symlink?("/etc/php5/fpm/conf.d/20-oci8.ini")
  end
end
