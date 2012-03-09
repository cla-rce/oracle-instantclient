include_recipe "samba::server"

# disable the nmbd service (not needed)
begin
  s = resources(:service => "nmbd") # reopen from samba cookbook
  s.action [:disable, :stop]
rescue Chef::Exceptions::ResourceNotFound
  service "nmbd" do
    action [:disable, :stop]
  end
end

# replace samba config with CLASS-specific config
t = nil
begin
  t = resources(:template => node['class_samba']['config']) # reopen from samba cookbook
rescue Chef::Exceptions::ResourceNotFound
  t = template node['class_samba']['config']
end

t.cookbook "class_samba"
t.source "smb.conf.erb"
t.mode "0644"
t.notifies :restart, resources(:service => "smbd")

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
