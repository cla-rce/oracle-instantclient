# Dependencies
### assume this is there from base
#include_recipe "unison::default"

# generate servers.conf file
template "/etc/servers.conf" do
  source "servers.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :servers => node['class_clustersync']['servers']
  )
end

# generate push-files script
template "/usr/local/scripts/push-files" do
  source "push-files.erb"
  owner "root"
  group "root"
  mode "0700"
end

# generate push validator
template "/usr/local/scripts/validate-push" do
  source "validate-push.erb"
  owner "root"
  group "root"
  mode "0700"
end

# Create unison state directory
directory "/var/state/unison/" do
  owner "root"
  group "root"
  mode "0700"
  action :create
  recursive true
end

# Create root ssh directory
directory "/root/.ssh/" do
  owner "root"
  group "root"
  mode "0700"
  action :create
end

# Add SSH key to root account
cookbook_file "/root/.ssh/sync_key" do
  source "sync_key"
  owner "root"
  group "root"
  mode "0600"
end

cookbook_file "/root/.ssh/sync_key.pub" do
  source "sync_key.pub"
  owner "root"
  group "root"
  mode "0644"
end

# Copy key to authorized keys
execute "add authorized key" do
  user "root"
  cwd "/root"
  command "echo -n 'no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty,command=\"/usr/local/scripts/validate-push\" ' | cat - /root/.ssh/sync_key.pub >> /root/.ssh/authorized_keys"
  not_if "grep '/usr/local/scripts/validate-push' /root/.ssh/authorized_keys"
end
