default[:cla_users][:local_admin_home] = "/var/local_admin/home"
default[:cla_users][:local_admin_group] = "local_admins"
# from a debian reserved range 65000 - 65533
default[:cla_users][:local_admin_group_gid] = 65001

default[:cla_users][:local_user_home] = "/home"
default[:cla_users][:local_user_group] = "local_users"
# from a debian reserved range 65000 - 65533
default[:cla_users][:local_user_group_gid] = 65002
default[:cla_users][:local_users_on_host] = []
default[:cla_users][:local_users_use_password] = true
default[:cla_users][:local_users_add_ssh_keys] = true