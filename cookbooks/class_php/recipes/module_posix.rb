if platform?("centos","redhat","fedora","suse","scientific")
  # install process module
  package "php-process" do
    action :install
  end

  # deactivate unneeded sysv modules
  ### removed -jjb
  ### don't break the package database by removing, replace if absolutely cannot be present

#  %w{ sysvmsg sysvsem sysvshm }.each do |mod|
#    file "#{node['php']['ext_conf_dir']}/#{mod}.ini" do
#      action :delete
#    end
#  end
end