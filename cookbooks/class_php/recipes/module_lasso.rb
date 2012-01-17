include_recipe "lasso"

# Install php module
if platform?("debian","ubuntu")
  package "php5-lasso"

elsif platform?("centos","redhat","fedora","suse","scientific")
  # Copy the lasso php module into the correct directory
  execute "copying lasso php modules" do
    if File.exists?("/usr/local/lib64/php/modules/lasso.so")
      command "cp /usr/local/lib64/php/modules/lasso.so #{node['php']['extension_dir']}"
    else
      command "cp /usr/local/lib/php/modules/lasso.so #{node['php']['extension_dir']}"
      only_if "test -f /usr/local/lib/php/modules/lasso.so"
    end
    not_if { File.exists?("#{node['php']['extension_dir']}/lasso.so") }
  end
end

# Add lasso.ini to /etc/php.d
template "#{node['php']['ext_conf_dir']}/lasso.ini" do
  source "extension.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :name => "lasso",
    :directives => {}
  )
  only_if { File.exists?("#{node['php']['extension_dir']}/lasso.so") }
end
