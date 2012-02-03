#
# Cookbook Name:: cla_unix_baseline
# Recipe:: class_appserver
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

## merged from class perl::modules, crimson-tools::default, freetds, lasso (partial, no RH),
##   

#### Done: jansson package
#### Done: eaccelerator
#### Done: gituser recipe
  ## keep separate
#### STUB: classadm::apache2
#### Done: class crontasks
  ## this creats a task user and sets up sudo rights
  ## keep separate
#### Done: class vhosts
  ## keep separate, rename class_vhosts
#### Done: class clustersync
  ## keep separate, rename class_clustersync
  
# role runlist (for slave) needs this, gituser::default, crontasks::default, 
#   class_hosts::default, class_clustersync::default
# role runlist (for master) needs change to class_clustersync::master


# merged from many of their cookbooks.
ubuntu_lucid_plist = %w{ unison wv xpdf poppler-utils html2ps tidy aspell aspell-en 
  imagemagick gsfonts freetds-bin liblasso3 php5-lasso php5-eaccelerator php5-sqlite
  libjansson-dev libjansson4 rssh }

### not implemented for rhel: lasso eaccelerator jansson, no nodes expected on rhel
###   but maintaining as much as possible in case of future use
rh_5_plist = %w{ unison227 wv xpdf poppler-utils html2ps tidy aspell aspell-en 
  ImageMagick ghostscript-fonts freetds rssh }

case node[:platform]
when "ubuntu"
  ubuntu_lucid_plist.each do |pkg|
    package pkg
  end  
  perl_modules = %w{ libdbi-perl libdbd-mysql-perl libnet-ssleay-perl libdigest-sha1-perl 
    libtimedate-perl libio-zlib-perl libarchive-zip-perl libdate-manip-perl libcurses-perl 
    libalgorithm-diff-perl }
  
when "redhat", "centos" 
  Chef::Log.warn("CLASS packages may not be fully implemented for platform")
  rh_5_plist.each do |pkg|
    package pkg
  end
  perl_modules = %w{ perl-DBI perl-DBD-MySQL perl-Net-SSLeay perl-Digest-SHA1 perl-TimeDate 
    perl-IO-Zlib perl-Archive-Zip perl-Archive-Tar perl-DateManip perl-Curses perl-Algorithm-Diff }
  
end

### ensure perl, from CLASS perl::modules recipe
include_recipe "perl"

include_recipe "mysql::client"

include_recipe "apache2::default"
include_recipe "class_apache2::default"
include_recipe "apache2::mod_cgi"
include_recipe "apache2::mod_deflate"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mod_dir"
include_recipe "apache2::mod_ssl"

## need a bunch of php stuff
include_recipe "php::default"
# this will overwrite php.ini and other stuff
# we include from opscode recipe where possible, so that
# the resource providers don't get overwritten
include_recipe "class_php::default"
include_recipe "php::module_curl"
## needs to be built to package, not hack that exists now
#include_recipe "class_php::module_eaccelerator"
include_recipe "php::module_gd"
include_recipe "class_php::module_imap"

## don't use the recipe, just use package.
# already included in package_list above
# package "php5-lasso"
#include_recipe "class_php::module_lasso"

include_recipe "php::module_ldap"
include_recipe "class_php::module_memcached"
include_recipe "class_php::module_mssql"
include_recipe "php::module_mysql"
include_recipe "class_php::module_pdo"
include_recipe "class_php::module_posix"
include_recipe "class_php::module_soap"
include_recipe "class_php::module_tidy"
include_recipe "class_php::module_xml"
include_recipe "class_php::module_xsl"

include_recipe "apache2::mod_php5"

# from perl::modules as modified by CLASS
perl_modules.each do |pkg|
  package pkg do
    action :install
  end
end

# from freetds::default
template "/etc/freetds.conf" do
  source "freetds.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end

# install rssh.conf with sftp/scp access
template "/etc/rssh.conf" do
  source "rssh.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end

# install phpdoc from pear
php_pear "PhpDocumentor" do
  action :install
end

# sudo commands for managing apache, memcached, clustersync, and chef
cla_sudo_commands "class_appserver" do
  allowed_group "classadm"
  target_user "root"
  commands [
    "/etc/init.d/apache2 *",
    "/sbin/service apache2 *",
    "/usr/sbin/a2dismod, /usr/sbin/a2enmod, /usr/sbin/a2dissite, /usr/sbin/a2ensite",
    "/etc/init.d/memcached *",
    "/sbin/service memcached *",
    "/data/scripts/push-files",
    "/usr/bin/chef-client \"\"",
    "/var/lib/gems/1.8/bin/chef-client \"\""
  ]
end
