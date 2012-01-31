include_recipe "samba::server"

# disable the nmbd service (not needed)
service "nmbd" do
  action [:disable, :stop]
end

# declare the smbd service
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
