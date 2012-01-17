if platform?("debian","ubuntu")
  package "checkinstall" # for building eaccelerator package
end

# compile and install eaccelerator
# (unfortunately the epel rhel 6 package causes seg faults)

cookbook_file "/tmp/eaccelerator-0.9.6.1.tar.bz2" do
  not_if { File.exists?("#{node['php']['extension_dir']}/eaccelerator.so") }
end

execute "unpack eaccelerator" do
  cwd "/tmp"
  command "tar jxvf /tmp/eaccelerator-0.9.6.1.tar.bz2"
  only_if { File.exists?("/tmp/eaccelerator-0.9.6.1.tar.bz2") }
  not_if { File.exists?("#{node['php']['extension_dir']}/eaccelerator.so") }
end

execute "compile and install eaccelerator" do
  cwd "/tmp/eaccelerator-0.9.6.1"
  case node[:platform]
  when "debian","ubuntu"
    command "phpize && ./configure && make && checkinstall"
  else
    command "phpize && ./configure && make && make install"
  end
  creates "#{node['php']['extension_dir']}/eaccelerator.so"
end

template "#{node['php']['ext_conf_dir']}/eaccelerator.ini" do
  source "eaccelerator.ini.erb"
  owner "root"
  group "root"
  mode "0644"
end

if node.has_key?("apache")
  directory node['php']['eaccelerator_cache_dir'] do
    owner node['apache']['user']
    group node['apache']['group']
    mode "0750"
  end
end