maintainer       "Joshua Buysse, (C) Regents of the University of Minnesota"
maintainer_email "buysse@umn.edu"
license          "Apache 2.0"
description      "Installs/Configures cla_unix_baseline"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))

version          "0.9.11"

supports "ubuntu", ">= 10.04"
supports "redhat", ">= 5.0"
supports "centos", ">= 5.0"

depends "apt"
depends "cla_shell"
depends "cla_sudo"
depends "class_git"
depends "postfix"
depends "cla_clamav"
depends "perl"
depends "memcached"
depends "mysql"
depends "apache2"
depends "class_phpmysqlsessions"
depends "class_php"
depends "cla_cronjobs"
depends "logrotate"
depends "ntp"

