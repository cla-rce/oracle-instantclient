package "php-imap" do
  case node[:platform]
  when "debian","ubuntu"
    package_name "php5-imap"
  when "centos","redhat","fedora","suse","scientific"
    package_name "php-imap"
  end
  action :install
end

# replace ubuntu's imap conf which uses # comments and triggers deprecated messages
if platform?("ubuntu")
  template "#{node['php']['ext_conf_dir']}/imap.ini" do
    source "extension.ini.erb"
    owner "root"
    group "root"
    mode "0644"
    variables(
      :name => "imap",
      :directives => {}
    )
  end
end