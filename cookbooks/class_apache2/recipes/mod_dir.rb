include_recipe "apache2::default"

template "#{node[:apache][:dir]}/mods-available/dir.conf" do
  source "dir.conf.erb"
  mode 0644
end

apache_module "dir"
