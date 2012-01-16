# grab classadm users
users = search(:users, "classadm:true").collect{|u| u['id']}

# create the classadm group
group node[:class_classadm][:group] do
  members users
  action :create
end

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
