include_recipe "samba::default"

# remove vendor default sites
%w{ default default-ssl }.each do |f|
  file "#{node[:apache][:dir]}/sites-available/#{f}" do
    action :delete
    backup false
    only_if "grep 'DocumentRoot /var/www/' #{node[:apache][:dir]}/sites-available/#{f}"
  end
end

# add additional security directives
template "#{node[:apache][:dir]}/conf.d/class_security" do
  source "class_security.erb"
  notifies :restart, resources(:service => "apache2")
  mode 0644
end