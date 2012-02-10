include_recipe "php::default"

# update php.ini
if platform?("debian","ubuntu")
  %w{ apache2 cli cgi }.each do |sapi|
    template "#{node['class_php']['conf_dir']}/#{sapi}/php.ini" do
      source "php.ini.erb"
      owner "root"
      group "root"
      mode "0644"
      only_if "test -d #{node['class_php']['conf_dir']}/#{sapi}"
    end
  end
elsif platform?("centos","redhat","fedora","suse","scientific")
  template "#{node['class_php']['conf_dir']}/php.ini" do
    source "php.ini.erb"
    owner "root"
    group "root"
    mode "0644"
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