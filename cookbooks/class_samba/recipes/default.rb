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

# add the sambapasswd script to /usr/local/bin/
template "/usr/local/bin/sambapasswd" do
  source "sambapasswd.erb"
  owner "root"
  group "root"
  mode "0755"
end

# add the sambapasswd script to sudoers
cla_sudo_commands "class_samba" do
  allowed_group "classdev"
  target_user "root"
  commands [ "/usr/local/bin/sambapasswd \"\"" ]
end
