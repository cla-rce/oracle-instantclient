maintainer       "Joshua Buysse, (C) Regents of the University of Minnesota"
maintainer_email "buysse@umn.edu"
license          "Apache 2.0"
description      "Installs/Configures cla_unix_baseline"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))

version          "0.0.1"

supports "ubuntu", ">= 10.04"
supports "redhat", ">= 5.0"
supports "centos", ">= 5.0"

depends "cla_shell"