#
# Cookbook Name:: cla_unix_baseline
# Recipe:: cla_web_base
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

ubuntu_lucid_plist = %w{ unison wv html2ps tidy aspell aspell-en 
  imagemagick gsfonts }

rh_5_plist = %w{ unison227 wv html2ps tidy aspell aspell-en 
  ImageMagick ghostscript-fonts }

case node[:platform]
when "ubuntu"
  ubuntu_lucid_plist.each do |pkg|
    package pkg
  end  
  perl_modules = %w{ }
  
when "redhat", "centos" 
  Chef::Log.warn("CLA web packages may not be fully implemented for platform")
  rh_5_plist.each do |pkg|
    package pkg
  end
  perl_modules = %w{ }
  
end

### ensure perl, from CLASS perl::modules recipe
include_recipe "perl"

include_recipe "mysql::client"
include_recipe "apache2::default"
include_recipe "apache2::mod_deflate"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mod_ssl"

