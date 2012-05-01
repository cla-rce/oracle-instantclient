#
# Cookbook Name:: cla_unix_baseline
# Recipe:: nx_terminal_server
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

## ubuntu not implemented completely, will work on that.
ubuntu_lucid_plist = %w{ ubuntu-desktop kubuntu-desktop  }

## ugly hack for now, until the yum provider is updated to 
## handle installing groups of packages
rh_5_yum_grouplist = [
  "Administration Tools",
  "Authoring and Publishing",
  "Development Tools",
  "Editors",
  "Engineering and Scientific",
  "GNOME Desktop Environment",
  "GNOME Software Development",
  "Games and Entertainment",
  "Graphical Internet",
  "Graphics",
  "KDE (K Desktop Environment)",
  "KDE Software Development",
  "Legacy Network Server",
  "Legacy Software Development",
  "Legacy Software Support",
  "Office/Productivity",
  "Printing Support",
  "Server Configuration Tools",
  "Sound and Video",
  "System Tools",
  "Text-based Internet",
  "X Software Development",
  "X Window System",
  "Window Managers"
  ]
  
  
# these are packages that are optional in the groups, but still needed on the box  
rh_5_plist = %w{ tetex-xdvi emacs nedit thunderbird firefox graphviz gv gimp xfig
  alpine lynx git mercurial subversion cvs dia plotutils rdesktop recode ruby-mode
  ruby-tcltk expect tix tkinter xpdf 
  }

## some of these need the RHEL 5 supplemental or productivity repos 
## and don't work on CentOS directly
### install with ignore_failure true
rh_5_optional_plist = %w{ WindowMaker acroread acroread-plugin flash-plugin cla-ssh-add-wrapper 
  evolution evolution-webcal finch fluxbox fortune-mod fvwm gnome-spell icewm inkscape kdeaddons 
  kdegames kdegraphics kdepim konversation lv lyx lyx-fonts nethack 
  openoffice.org-calc openoffice.org-core openoffice.org-draw openoffice.org-graphicfilter openoffice.org-impress
  openoffice.org-math openoffice.org-writer openoffice.org-xsltfilter
  planner pidgin scribus taskjuggler
  }

case node[:platform]
when "ubuntu"
  Chef::Log.warn("NX terminal server packages may not be fully implemented for platform")
  ubuntu_lucid_plist.each do |pkg|
    package pkg
  end  
  
when "redhat", "centos" 
  ## expand groups to append to package list
  rh_5_yum_grouplist.each do |pgrp|
    # expand it with shell call to yum
    md = false
    id = false
    io = false
    pkgs_in_group = `/usr/bin/yum groupinfo "#{pgrp}"`
    pkgs_in_group.each_line do |line| 
      line.chomp!
      if line =~ /Mandatory Packages:/ then
        md = true
        id = false
        io = false
        next
      end
      if line =~ /Default Packages:/ then
        md = false
        id = true
        io = false
        next
      end
      if line =~ /Optional Packages:/ then
        md = false
        id = false
        io = true
        next
      end
      # remove leading spaces from package name
      line.lstrip!
      if md then 
        rh_5_plist << line
      end
      if id then 
        rh_5_plist << line
      end
    end
  end
  ### adding the groups may have made duplicates, remove them
  rh_5_plist.uniq!
  
  rh_5_plist.each do |pkg|
    package pkg
  end
  rh_5_optional_plist.each do |pkg|
    package pkg do 
      ignore_failure true 
    end
  end
end
