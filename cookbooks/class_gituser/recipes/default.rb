#include_recipe "git"

# add the git user
user node['gituser']['user'] do
  home node['gituser']['home_dir']
  comment "git user"
  shell "/bin/bash"
  system true
  supports :manage_home => true
end

directory "#{node['gituser']['home_dir']}/packages" do
  owner node['gituser']['user']
  group node['gituser']['group']
  mode "0700"
end

%w{ git_home git_scripts minion-git-userdir-live }.each do |name|
  cookbook_file "#{node['gituser']['home_dir']}/packages/#{name}.tar.gz" do
    source "#{name}.tar.gz"
    owner node['gituser']['user']
    group node['gituser']['group']
    mode "0600"
    not_if { File.exists?("#{node['gituser']['home_dir']}/packages/#{name}.tar.gz") }
  end
end

# create the git home directory
execute "tar zxvf #{node['gituser']['home_dir']}/packages/git_home.tar.gz" do
  cwd node['gituser']['home_dir']
  user node['gituser']['user']
  group node['gituser']['group']
  not_if { File.exists?("#{node['gituser']['home_dir']}/gitserver") }
end

# create the git repository
directory node['gituser']['gitroot_dir'] do
  owner node['gituser']['user']
  group node['gituser']['group']
  mode "0700"
  recursive true
end

execute "tar zxvf #{node['gituser']['home_dir']}/packages/minion-git-userdir-live.tar.gz" do
  cwd node['gituser']['gitroot_dir']
  user node['gituser']['user']
  group node['gituser']['group']
  not_if { File.directory?("#{node['gituser']['gitroot_dir']}/minion-git-userdir-live.git") }
end

# create git scripts
directory node['gituser']['scripts_dir'] do
  mode "0755"
  recursive true
end

execute "tar zxvf #{node['gituser']['home_dir']}/packages/git_scripts.tar.gz" do
  cwd node['gituser']['scripts_dir']
  not_if { File.exists?("#{node['gituser']['scripts_dir']}/git-sign") }
end

%w{ git-create-repo git-sign git-transfer git-verify-tagger }.each do |script|
  file "#{node['gituser']['scripts_dir']}/#{script}" do
    mode "0755"
  end

  link "/usr/local/bin/#{script}" do
    to "#{node['gituser']['scripts_dir']}/#{script}"
  end
end
