#
# Cookbook Name:: cla_unix_baseline
# Recipe:: base_packages
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

ubuntu_lucid_plist = %w( python perl gfortran gfortran-multilib ispell wamerican tcl tk tix
blt tclreadline expect expectk python-software-properties build-essential git-core git-svn
ruby-full libtcltk-ruby vim emacs ctags vim-common nano openssh-server acct acl alpine-pico
apt-file apt-listchanges beav bsdgames bsdgames-nonfree buffer bvi bzip2 cadaver cfengine2
cpio curl dconf debget debhelper detox devscripts dialog enscript extract file fortune-mod
fortunes-bofh-excuses fortunes fortunes-spam gdb getlibs gnupg gnupg-doc gnuplot gnuplot-doc
gnuplot-x11 gobjc gpc graphviz graphviz-dev graphviz-doc indent ksh ldap-utils lftp links
lynx m4 mailutils memstat multitail mysql-client ncftp newbiedoc nfs4-acl-tools ntp ntpdate
numactl openipmi openssh-blacklist openssl-blacklist openssh-blacklist-extra
openssl-blacklist-extra openssl openssl-doc p7zip perl-doc perl-tk pkgsync psutils pv
python-docutils python-openssl python-setuptools python-setupdocs python-tk rubygems screen
sharutils shtool strace subversion subversion-tools sudo sysstat tcsh trend wget whois
libcompress-zlib-perl libdbd-csv-perl libdbd-mysql-perl libdbi-perl libdbd-pg-perl
libdbd-sqlite3-perl libwww-perl python-gtk2 python-glade2 python-sqlite python-ldap
python-libxml2 intelcompilers-libstdc++5-compat autofs5 ruby-dev xinetd ia32-libs 
cvs )

rh_5_plist = %w( python python-devel perl perl-devel perl-Tk ruby ruby-devel ruby-rdoc ruby-ri ruby-irb 
gcc-gfortran gcc-c++ gcc-objc aspell aspell-en tcl tcl-devel tclx tclx-devel tk tk-devel tix expect expectk 
git-all subversion vim emacs ctags nano psacct acl bzip2 cadaver cpio curl dialog enscript file 
fortune-mod gdb gnupg gnuplot graphviz graphviz-devel graphviz-gd indent ksh openldap openldap-devel
lftp elinks lynx m4 mailx mysql mysql-devel ncftp ntp OpenIPMI screen sudo sysstat tcsh wget xinetd 
cvs)

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
