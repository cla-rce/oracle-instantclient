name             "oracle-instantclient"
maintainer       "Joshua Buysse, (C) Regents of the University of Minnesota"
maintainer_email "buysse@umn.edu"
license          "Apache 2.0"
description      "Installs/Configures oracle-instantclient"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.5.2"

supports "centos", ">= 6.0"
supports "redhat", ">= 6.0"
supports "ubuntu", ">= 14.04"

chef_version ">= 12.1" if respond_to?(:chef_version)

source_url "https://github.com/cla-rce/oracle-instantclient" if respond_to?(:source_url)
issues_url "https://github.com/cla-rce/oracle-instantclient/issues" if respond_to?(:issues_url)
