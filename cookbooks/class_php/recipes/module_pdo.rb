# installed by default on ubuntu

if platform?("centos","redhat","fedora","suse","scientific")
  package "php-pdo" do
    action :install
  end
end