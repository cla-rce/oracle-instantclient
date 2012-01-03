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

## merged from class perl::modules, crimson-tools::default, 

ubuntu_lucid_plist = %w{ unison wv xpdf poppler-utils html2ps tidy aspell aspell-en imagemagick gsfonts}

rh_5_plist = %w{ unison227 wv xpdf poppler-utils html2ps tidy aspell aspell-en ImageMagick ghostscript-fonts}

case node[:platform]
when "ubuntu"
  ubuntu_lucid_plist.each do |pkg|
    package pkg
  end  
  perl_modules = %w{ libdbi-perl libdbd-mysql-perl libnet-ssleay-perl libdigest-sha1-perl libtimedate-perl libio-zlib-perl libarchive-zip-perl libdate-manip-perl libcurses-perl libalgorithm-diff-perl }
  
when "redhat", "centos" 
  Chef::Log.warn("CLASS packages may not be fully implemented for platform")
  rh_5_plist.each do |pkg|
    package pkg
  end
  perl_modules = %w{ perl-DBI perl-DBD-MySQL perl-Net-SSLeay perl-Digest-SHA1 perl-TimeDate perl-IO-Zlib perl-Archive-Zip perl-Archive-Tar perl-DateManip perl-Curses perl-Algorithm-Diff }
  
end

### ensure perl, from CLASS perl::modules recipe
include_recipe "perl"


perl_modules.each do |pkg|
  package pkg do
    action :install
  end
end