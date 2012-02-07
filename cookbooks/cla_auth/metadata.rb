maintainer       "Joshua Buysse, (C) Regents of the University of Minnesota"
maintainer_email "buysse@umn.edu"
license          "Apache 2.0"
description      "Installs/Configures cla_auth"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.3.2"

%w{redhat centos ubuntu }.each do |os|
  supports os
end

