# make sure the sessions directory exists
directory "#{node['class_phpmysqlsessions']['path']}" do
  owner "root"
  group "classadm"
  mode "2775"
  recursive true
  not_if "test -d #{node['class_phpmysqlsessions']['path']}"
end

# generate the mysql session handler
template "#{node['class_phpmysqlsessions']['path']}/mysql_session_handler.php" do
  source "mysql_session_handler.php.erb"
  owner "root"
  group "classadm"
  mode "0664"
  action :create_if_missing
end

template "#{node['class_phpmysqlsessions']['path']}/cleanup_php_sessions.php" do
  source "cleanup_php_sessions.php.erb"
  owner "root"
  group "classadm"
  mode "0664"
  action :create_if_missing
end