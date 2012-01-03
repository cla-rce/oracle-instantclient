if platform?("centos","redhat","fedora","suse","scientific")
  package "php-xml" do
    action :install
  end
end