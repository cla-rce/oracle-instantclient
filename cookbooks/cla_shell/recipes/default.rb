#
# Cookbook Name:: cla_shell
# Recipe:: default
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

### this replaces /home/system/custom/shell-startup/Install for new systems

directory "/etc/profile.d" do
  owner "root"
  group "root"
end

remote_directory "/etc/profile.d/cla_shell_fragments" do
  source "profile.d"
  owner "root"
  group "root"
  mode "0755"
  files_owner "root"
  files_group "root"
  files_mode "0755"
  action :create
  notifies :run, "script[clean_shell_fragment_symlinks]"
end

script "clean_shell_fragment_symlinks" do 
  interpreter "/bin/bash"
  action :nothing
  code <<-EOH
  cd /etc/profile.d
  for i in cla_shell_fragments/*.sh cla_shell_fragments/*.csh ; do 
    # check for existence of file in current dir
    fname = `basename $i`
    if [ ! -L "$fname" ]; then
      if [ -e "$fname" ]; then
        # it's not a link; set it aside
        mv $fname $fname__chef_moved_$$_ORIG
      fi
      # create the link
      ln -sf $i
    fi
  done
  # now, search the links in the directory for ones that don't exist
  for i in *.sh *.csh ; do 
    if [ -L "$i" -a ! -e "$i" ]; then
      # bad symlink
      echo "Removing symlink: $i"
      rm "$i"
    fi
  done
  EOH
end
