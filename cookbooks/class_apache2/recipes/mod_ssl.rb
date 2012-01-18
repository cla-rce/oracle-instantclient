include_recipe "apache2::mod_ssl"

template "#{node[:apache][:dir]}/mods-available/ssl.conf" do
  source "ssl.conf.erb"
  mode 0644
end

apache_module "ssl"
