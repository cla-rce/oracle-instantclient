#
# Cookbook Name:: cla_terrapop
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


# set up database bits
include_recipe "postgresql::default"
include_recipe "mysql::client"

# install java
include_recipe "java::default"

# install some basic packages on all hosts; this will probably grow
pkgs = %w{ gdal-bin }
pkgs.each do |p|
  package p do 
    action :install
  end
end



### Set up ruby environment baseline
include_recipe "rvm::system_install"

install_rubies = [ "1.9.3", "jruby" ]
install_gems_global = [ "bundler", "mysql", "pg" ]
install_rubies.each do |rb|
  rvm_ruby rb do
    action :install
  end
  install_gems_global.each do |rbgem|
    rvm_gem rbgem do 
      ruby_string rb
      action :install
    end
  end
end
