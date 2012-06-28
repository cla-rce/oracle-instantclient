maintainer       "Joshua Buysse, (C) Regents of the University of Minnesota"
maintainer_email "buysse@umn.edu"
license          "Apache 2.0"
description      "Installs/Configures cla_terrapop"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends "java"
depends "rvm" 
depends "postgresql"
depends "cla_unix_baseline"
depends "mysql"

# pending writing this one
#depends "cla_postgis"