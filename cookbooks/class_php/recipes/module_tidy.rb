package "php-tidy" do
  case node[:platform]
  when "debian","ubuntu"
    package_name "php5-tidy"
  when "centos","redhat","fedora","suse","scientific"
    package_name "php-tidy"
  end
  action :install
end
