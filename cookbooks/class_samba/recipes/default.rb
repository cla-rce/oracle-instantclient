include_recipe "samba::server"

# declare the samba service
service "smbd" do
  action :nothing
end

# replace samba config with CLASS-specific config
template node['class_samba']['config'] do
  source "smb.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "smbd")
end
