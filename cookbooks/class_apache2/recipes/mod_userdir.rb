include_recipe "apache2"

template "#{node[:apache][:dir]}/mods-available/userdir.conf" do
  source "userdir.conf.erb"
  mode 0644
end

apache_module "userdir"
