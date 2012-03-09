include_recipe "php::default"

# php.ini locations
# - debian/ubuntu uses separate php.ini files for each sapi
# - redhat uses one php.ini for all sapis
conf_dirs = value_for_platform(
  [ "debian", "ubuntu" ] => {
    "default" => [
      "#{node['class_php']['conf_dir']}/apache2",
      "#{node['class_php']['conf_dir']}/cli",
      "#{node['class_php']['conf_dir']}/cgi"
    ]
  },
  "default" => [ node['class_php']['conf_dir'] ]
)

# update php.ini with CLASS configuration
conf_dirs.each do |conf_dir|
  if ::File.exists?(conf_dir)
    t = nil

    begin
      t = resources(:template => "#{conf_dir}/php.ini") # reopen resource from php cookbook
    rescue Chef::Exceptions::ResourceNotFound
      t = template "#{conf_dir}/php.ini" # new resource
    end

    t.cookbook "class_php"
    t.source "php.ini.erb"
    t.cookbook "class_php"
    t.mode "0644"
  end
end

# make sure apache group owns sessions directory
if node.has_key?("apache") and node['class_php']['session_save_handler'] == "files"
  directory node['class_php']['session_save_path'] do
    group node['apache']['group']
    mode 0770
    recursive true
  end
end
