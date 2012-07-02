#
# Cookbook Name:: cla_terrapop
# Recipe:: web_rails
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

include_recipe "cla_terrapop::default"
include_recipe "cla_terrapop::web"

### Set up ruby environment
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

rvm_gem "passenger" do 
  ruby_string "1.9.3"
  action :install
end

# configure passenger for Apache
# stub

# set up vhosts
# for the moment, hard code.  Move to data bag after working.
include_recipe "apache2::mod_ssl"

# use lwrp from apache2 cookbook
vhosts = ['demo.data.terrapop.org', 'dev.data.terrapop.org', 'staging.data.terrapop.org']

vhosts.each do |vh|
  # ensure that docroot is there
  ### STUB: assuming group terrapop already exists
  directory "/web/#{vh}" do 
    owner "root"
    group "terrapop"
    mode "02775"
  end
  
  directory "/web/#{vh}/htdocs" do 
    owner "root"
    group "terrapop"
    mode "02775"
  end
  
  directory "/web/#{vh}/rails" do 
    owner "root"
    group "terrapop"
    mode "02775"
  end
  
  # set up the cert directories and ensure that they're there
  # STUB: ubuntu configuration; may not work on other os due to missing group
  directory "/etc/ssl" do
    owner "root"
    group "root"
    mode "0755"
  end
  directory "/etc/ssl/certs" do 
    owner "root"
    group "root"
    mode "0755"
  end
  directory "/etc/ssl/private" do 
    owner "root"
    group "ssl-cert"
    mode "0710"
  end

  file "/etc/ssl/certs/#{vh}.crt" do 
    source "#{vh}.crt"
    owner "root"
    group "root"
    mode "0644"
  end
  
#  file "/etc/ssl/certs/#{vh}_intermediate.crt" do 
#    source "#{vh}_intermediate.crt"
#    owner "root"
#    group "root"
#    mode "0644"
#  end
  
  file "/etc/ssl/private/#{vh}.key" do 
    source "#{vh}.key"
    owner "root"
    group "root"
    mode "0600"
  end

  # actually configure vhosts.
  # overriding the template to add SSL support to the apache2 recipe
  ## STUB: contribute code back to opscode on apache2 cookbook
  web_app "#{vh}" do 
    server_name vh
    docroot "/web/#{vh}/htdocs"
    template "rails_web_app.conf.erb"
  end

  web_app "#{vh}_ssl" do 
    server_name vh
    docroot "/web/#{vh}/htdocs"
    template "rails_web_app.conf.erb"
    ssl_enabled true
    ssl_certificate_file "/etc/ssl/certs/#{vh}.crt"
    ssl_certificate_key_file "/etc/ssl/private/#{vh}.key"
#    ssl_certificate_chain_file "/etc/ssl/certs/#{vh}_interm.crt"
  end
end
