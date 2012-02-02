# need Etc.getgrnam()
require 'etc'
#
# Create the dbrep user's home environment
#

# create the dbrep user
user "dbrep" do
  comment "dbReplication user"
  home "/home/dbrep"
  shell "/bin/bash"
  system true
  supports :manage_home => true
end

# add user to mysql management groups so that dbrep can hot copy tables
%w{ dev_mysql test_mysql prod_mysql }.each do |grp|
  #### We'll either open the existing resource, or create a new one within chef
  #### see http://wiki.opscode.com/display/chef/Definitions, search for "reopening resources"
  gres = nil
  begin
    gres = resources(:group => grp)
  rescue Chef::Exceptions::ResourceNotFound
    # only go forward if group is on the local system, but hasn't been mentioned
    # yet in a chef recipe
    begin
      Etc.getgrnam(grp)
      gres = group grp do
        append false
        action [:create, :modify, :manage]
      end
    rescue ArgumentError => e
      Chef::Log.warn("Tried to add dbrep to nonexistent group #{grp}")
    end
  end
  # if the group didn't exist on the system, and won't be created by this chef run, 
  # don't create it now and keep moving.
  next if gres.nil?
  gres.members(gres.members | 'dbrep')
end

# add dbrep ssh config/keys
directory "/home/dbrep/.ssh" do
  owner "dbrep"
  group "dbrep"
  mode "0700"
end

%w{ authorized_keys id_rsa id_rsa.pub }.each do |file|
  cookbook_file "/home/dbrep/.ssh/#{file}" do
    source "#{file}"
    owner "dbrep"
    group "dbrep"
    mode "0600"
  end
end

# add ssh wrapper
cookbook_file "/home/dbrep/dbrep_server" do
  source "dbrep_server"
  owner "dbrep"
  group "dbrep"
  mode "0755"
end

# sudo commands for managing dbrep cron jobs
cla_sudo_commands "class_dbrep" do
  allowed_group "classadm"
  target_user "dbrep"
  commands [
    "/usr/bin/crontab *",
    "/bin/kill *",
    "/usr/bin/pkill *"
  ]
end

#
# Create the dbrep application directory
# (owned by git to allow for code deployments)
#

directory "/home/dbReplication" do
  owner node['class_gituser']['user']
  group node['class_gituser']['group']
  mode "0755"
end
