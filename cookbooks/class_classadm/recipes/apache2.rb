include_recipe "classadm"
include_recipe "apache2"

# grab classadm users
users = search(:users, "classadm:true").collect{|u| u['id']}

# add users to apache group
group node[:apache][:group] do
  members users
  append true
end

# ensure web logs are accessible by classadm users
directory node[:apache][:log_dir] do
  group node[:classadm][:group]
  mode "2775"
end

%w{ access_log error_log }.each do |log|
  file "#{node[:apache][:log_dir]}/#{log}" do
    mode "0644"
  end
end

# allow classadms to start/stop/restart apache/memcached
classadm_commands "apache2" do
  case node[:platform]
  when "centos","redhat","fedora","suse","scientific"
    commands [
      "/etc/init.d/httpd *",
      "/sbin/service httpd *",
      "/usr/bin/a2dismod, /usr/bin/a2enmod, /usr/bin/a2dissite, /usr/bin/a2ensite",
      "/etc/init.d/memcached *",
      "/sbin/service memcached *"
    ]
  when "debian","ubuntu"
    commands [
      "/etc/init.d/apache2 *",
      "/sbin/service apache2 *",
      "/usr/sbin/a2dismod, /usr/sbin/a2enmod, /usr/sbin/a2dissite, /usr/sbin/a2ensite",
      "/etc/init.d/memcached *",
      "/sbin/service memcached *"
    ]
  end
end
