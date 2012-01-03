package "php-memcached" do
  case node[:platform]
  when "debian","ubuntu"
    package_name "php5-memcached"
  when "centos","redhat","fedora","suse","scientific"
    package_name "php-pecl-memcached"
  end
  action :install
end
