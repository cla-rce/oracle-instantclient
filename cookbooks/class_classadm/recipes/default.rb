### moved group management to just be a supplemental group added to the user
### data bag entries and commented here. Had issues with users that didn't 
### exist on the system added to group and chef excepted out

# grab classadm users
#users = search(:local_users, "classadm:true").collect{|u| u['id']}

# create the classadm group
#group node[:class_classadm][:group] do
  #members users
  #action :create
#end

# ensure that the specified directories are writable by classadm users
node[:class_classadm][:dirs].each do |dir|
  directory dir do
    group node[:class_classadm][:group]
    mode "2775"
  end
end

# add classadm sudoers file
classadm_commands "default" do
  commands [
    "/usr/local/scripts/push-files",
    "/usr/bin/chef-client",
    "/var/lib/gems/1.8/bin/chef-client"
  ]
end
