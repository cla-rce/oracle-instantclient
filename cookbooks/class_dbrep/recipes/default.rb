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
  group grp do
    members ["dbrep"]
    append true
  end
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