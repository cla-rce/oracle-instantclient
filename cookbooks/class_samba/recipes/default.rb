include_recipe "samba::server"

# gather shares from data bag
shares = data_bag_item('samba', 'shares')

# update samba config file with additional directives
template node['samba']['config'] do
  source "smb.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables :shares => shares['shares']
  notifies :restart, resources(:service => svcs)
end

# add samba accounts for class users
unless node['samba']['passdb_backend'] =~ /^ldapsam/
  search('local_users').each do |u|
  if not (u['server_roles'] & node['roles']).empty?
    samba_user u['id'] do
      action [:create, :enable]
    end
  end
end
