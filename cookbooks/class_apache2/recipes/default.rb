include_recipe "apache2"
include_recipe "logrotate_37signals::default"

# disable vendor default sites
%w{ default-ssl }.each do |s|
  apache_site s do
    enable false
  end
end

# add additional security directives
template "#{node[:apache][:dir]}/conf.d/class_security" do
  source "class_security.erb"
  notifies :restart, resources(:service => "apache2")
  mode 0644
end

# create ssl directories (if they don't already exist)
%w{ crt key }.each do |dir|
  directory "#{node[:apache][:dir]}/ssl/#{dir}" do
    owner "root"
    group "root"
    mode 0755
    recursive true
  end
end

# ensure web root exists and has correct permissions
directory "#{node[:class_apache][:web_root][:dir]}" do
  owner node['class_gituser']['user'] if node.has_key?('class_gituser')
  group node[:class_apache][:web_root][:admin_group]
  mode "2775"
  recursive true
end

# ensure apache has write access to apache writable directories
%w{ photos ssdb_files user_files }.each do |dir|
  directory "#{node[:class_apache][:web_root][:dir]}/#{dir}" do
    owner node[:apache][:user]
    group node[:class_apache][:web_root][:admin_group]
    mode "2775"
  end
end

# ensure git/classadm write access to crimson htdocs directory
directory "#{node[:class_apache][:web_root][:dir]}/htdocs/crimson/" do
  owner node['class_gituser']['user'] if node.has_key?('class_gituser')
  group node[:class_apache][:web_root][:admin_group]
  mode "2775"
  recursive true
end

# ensure apache has write access to crimson dependency directories
%w{ archive modules editorTmp content page multimedia }.each do |dir|
  directory "#{node[:class_apache][:web_root][:dir]}/htdocs/crimson/dependancies/#{dir}" do
    owner node[:apache][:user]
    group node[:class_apache][:web_root][:admin_group]
    mode "2775"
    recursive true
  end
end

# ensure web logs are readable by users
directory node[:apache][:log_dir] do
  mode "0755"
end

%w{ access.log error.log }.each do |log|
  file "#{node[:apache][:log_dir]}/#{log}" do
    mode "0644"
  end
end

# rotate logs every month and preserve read-access
logrotate "apache2" do
  files ["/var/log/apache2/*.log"]
  frequency :monthly
  rotate_count 12
  rotate_if_empty false
  missing_ok true
  compress true
  restart_command "[ ! -f \"`. /etc/apache2/envvars ; echo ${APACHE_PID_FILE:-/var/run/apache2.pid}`\" ] || /etc/init.d/apache2 reload > /dev/null"
end
