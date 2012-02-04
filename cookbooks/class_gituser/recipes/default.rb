#include_recipe "git"

# add the git user
user node['class_gituser']['user'] do
  home node['class_gituser']['home_dir']
  comment "git user"
  shell "/bin/bash"
  system true
  supports :manage_home => true
end

# create the packages directory and copy the tarballs into it
directory "#{node['class_gituser']['home_dir']}/packages" do
  owner node['class_gituser']['user']
  group node['class_gituser']['group']
  mode "0700"
end

%w{ git_home git_scripts minion-git-userdir server_scripts }.each do |name|
  cookbook_file "#{node['class_gituser']['home_dir']}/packages/#{name}.tar.gz" do
    source "#{name}.tar.gz"
    owner node['class_gituser']['user']
    group node['class_gituser']['group']
    mode "0600"
  end
end

# extract the git home directory
execute "tar zxvf #{node['class_gituser']['home_dir']}/packages/git_home.tar.gz" do
  cwd node['class_gituser']['home_dir']
  user node['class_gituser']['user']
  group node['class_gituser']['group']
  not_if { File.exists?("#{node['class_gituser']['home_dir']}/gitserver") }
end

# create the git data directories
%w{ origin_dir live_dir scripts_dir }.each do |dir|
  if not node['class_gituser'][dir].empty?
    directory node['class_gituser'][dir] do
      owner node['class_gituser']['user']
      group node['class_gituser']['group']
      mode "0755"
      recursive true
    end
  end
end

# create the git test directory (if specified)
if not node['class_gituser']['test_dir'].empty?
  directory node['class_gituser']['test_dir'] do
    owner node['class_gituser']['user']
    group node['class_gituser']['test_group'] if not node['class_gituser']['test_group'].empty?
    mode "2775"
    recursive true
  end
end

# extract the scripts from a tarball (skip if scripts already present)
execute "tar zxvf #{node['class_gituser']['home_dir']}/packages/git_scripts.tar.gz" do
  cwd node['class_gituser']['scripts_dir']
  not_if { File.exists?("#{node['class_gituser']['scripts_dir']}/git-sign") }
end

# extract the scripts repo from tarball (skip if present)
execute "tar zxvf #{node['class_gituser']['home_dir']}/packages/server_scripts.tar.gz" do
  cwd node['class_gituser']['live_dir']
  not_if "test -d #{node['class_gituser']['live_dir']}/server_scripts.git"
end

# ensure correct permissions
%w{ git-create-repo git-micro git-sign git-transfer git-verify-tagger }.each do |script|
  file "#{node['class_gituser']['scripts_dir']}/#{script}" do
    mode "0755"
  end
end

# add scripts directory to the user path
%w{ sh csh }.each do |ext|
  template "/etc/profile.d/git-scripts.#{ext}" do
    source "git-scripts.#{ext}.erb"
    owner "root"
    group "root"
    mode "0644"
  end
end

# create the git userdir repo
execute "tar zxvf #{node['class_gituser']['home_dir']}/packages/minion-git-userdir.tar.gz" do
  cwd node['class_gituser']['live_dir']
  user node['class_gituser']['user']
  group node['class_gituser']['group']
  only_if "test ! -d #{node['class_gituser']['live_dir']}/minion-git-userdir.git || grep mordor3 #{node['class_gituser']['live_dir']}/minion-git-userdir.git/config"
end

# create the git macro directory (if path specified)
if not node['class_gituser']['macro_dir'].empty?
  directory node['class_gituser']['macro_dir'] do
    owner node['class_gituser']['user']
    group node['class_gituser']['macro_group']
    mode "2775"
    recursive true
  end
end

