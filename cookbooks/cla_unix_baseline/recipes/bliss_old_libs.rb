#
# Cookbook Name:: cla_baseline
# Recipe:: bliss_old_libs
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

#### called from bliss_compute_packages recipe

# Check platform
case node[:platform]
when "ubuntu"

  # create a few links for us for old libraries; cfengine lines in comments
  #/usr/lib32/libtiff.so.3 	->! 	/usr/lib32/libtiff.so.4 	type=relative
  execute "link_libtiff_3_32" do 
    only_if "test -e /usr/lib32/libtiff.so.4"
    cwd "/usr/lib32"
    command "/bin/ln -sf libtiff.so.4 libtiff.so.3"
  end
    
	#/lib32/libexpat.so.0 		->! 	/lib32/libexpat.so.1 		type=relative
	execute "link_libexpat_0_32" do 
    only_if "test -e /lib32/libexpat.so.1"
    not_if "test -e /lib32/libexpat.so.0"
    cwd "/lib32"
    command "/bin/ln -sf libexpat.so.1 libexpat.so.0"
  end
  
	#/usr/lib64/libtiff.so.3 	->! 	/usr/lib64/libtiff.so.4 	type=relative
	execute "link_libtiff_3_64" do 
    only_if "test -e /usr/lib64/libtiff.so.4"
    cwd "/usr/lib64"
    command "/bin/ln -sf libtiff.so.4 libtiff.so.3"
  end
  
	#/lib64/libexpat.so.0 		->! 	/lib64/libexpat.so.1 		type=relative
	execute "link_libexpat_0_64" do 
    only_if "test -e /lib64/libexpat.so.1"
    not_if "test -e /lib64/libexpat.so.0"
    cwd "/lib64"
    command "/bin/ln -sf libexpat.so.1 libexpat.so.0"
  end
  
 
  if node[:platform_version].to_f != 10.04 then
    Chef::Log.warn("Only tested for Ubuntu Lucid/10.04")
  end
when "redhat", "centos"
  Chef::Log.info("Nothing to do on RHEL/CentOS")
else
  Chef::Log.warn("Only implemented for Linux so far")
end
