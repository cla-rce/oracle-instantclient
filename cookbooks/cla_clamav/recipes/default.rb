if platform?("centos", "redhat", "fedora", "scientific", "suse")
  include_recipe "yum::epel"
end

package "clamav" do
  action :upgrade
end

package "clamav-db" do
  case node[:platform]
  when "centos","redhat","fedora","scientific","suse"
    package_name "clamav-db"
  when "debian","ubuntu"
    package_name "clamav-freshclam"
  end
  action :upgrade
end

directory "/usr/local/scripts" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

template "/usr/local/scripts/clamav.cron" do
  source "clamav.cron.erb"
  owner "root"
  group "root"
  mode "0700"
end

cron "clamav" do
  hour "1"
  minute "0"
  mailto "#{node[:clamav][:email_to]}"
  command "/usr/local/scripts/clamav.cron"
end