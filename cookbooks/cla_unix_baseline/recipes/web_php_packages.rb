#
# Cookbook Name:: cla_unix_baseline
# Recipe:: web_php_packages
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
include_recipe "cla_unix_baseline::web_packages"

ubuntu_lucid_plist = %w( libapache2-mod-php5 php5-cgi libphp-pclzip 
libphp-phpmailer libsparkline-php php-apc php-benchmark php-cache 
php-cache-lite php-compat php-crypt-gpg php-date php-db php-fpdf 
php-log php-mdb2 php-mdb2-driver-mysql php-mdb2-driver-sqlite php-mail 
php-mail-mime php-mdb2-driver-pgsql php-net-smtp php-net-socket 
php-net-ldap php-net-ldap2 php-net-ping php-soap php-xml-parser 
php-xml-rss php-xml-serializer php5-adodb php5-imagick php5-mcrypt
php5-memcache php5-memcached php5-suhosin phpunit phpunit-doc  
php-pear php5-curl php5-gd php5-dev php5-ldap php5-mysql php5-odbc 
php5-pgsql php5-pspell php5-sqlite php5-xmlrpc php5-sybase php5-xsl
)

# STUB:
rh_5_plist = %w( 
)

gem_list = %w( ) 

case node[:platform]
when "ubuntu"
  ubuntu_lucid_plist.each do |pkg|
    package pkg
  end
when "redhat", "centos" 
  rh_5_plist.each do |pkg|
    package pkg
  end
end

gem_list.each do |gem|
  gem_package gem
end
