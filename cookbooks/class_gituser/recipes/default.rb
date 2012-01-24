#include_recipe "git"

# add the git user
user node['class_gituser']['user'] do
  home node['class_gituser']['home_dir']
  comment "git user"
  shell "/bin/bash"
  system true
  supports :manage_home => true
end

directory "#{node['class_gituser']['home_dir']}/packages" do
  owner node['class_gituser']['user']
  group node['class_gituser']['group']
  mode "0700"
end

%w{ git_home git_scripts minion-git-userdir }.each do |name|
  cookbook_file "#{node['class_gituser']['home_dir']}/packages/#{name}.tar.gz" do
    source "#{name}.tar.gz"
    owner node['class_gituser']['user']
    group node['class_gituser']['group']
    mode "0600"
    not_if { File.exists?("#{node['class_gituser']['home_dir']}/packages/#{name}.tar.gz") }
  end
end

# create the git home directory
execute "tar zxvf #{node['class_gituser']['home_dir']}/packages/git_home.tar.gz" do
  cwd node['class_gituser']['home_dir']
  user node['class_gituser']['user']
  group node['class_gituser']['group']
  not_if { File.exists?("#{node['class_gituser']['home_dir']}/gitserver") }
end

# create git scripts
directory node['class_gituser']['scripts_dir'] do
  mode "0755"
  recursive true
end

# extract the scripts from a tarball (skip if scripts already present)
execute "tar zxvf #{node['class_gituser']['home_dir']}/packages/git_scripts.tar.gz" do
  cwd node['class_gituser']['scripts_dir']
  not_if { File.exists?("#{node['class_gituser']['scripts_dir']}/git-sign") }
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

# create the git origin directory (if path specified)
if not node['class_gituser']['origin_dir'].empty?
  directory node['class_gituser']['origin_dir'] do
    owner node['class_gituser']['user']
    group node['class_gituser']['group']
    mode "0755"
    recursive true
  end
end

# create the git test directory (if path specified)
if not node['class_gituser']['test_dir'].empty?
  directory node['class_gituser']['test_dir'] do
    owner node['class_gituser']['user']
    group node['class_gituser']['group']
    mode "0755"
    recursive true
  end
end

# create the git live directory
directory node['class_gituser']['live_dir'] do
  owner node['class_gituser']['user']
  group node['class_gituser']['group']
  mode "0755"
  recursive true
end

# create the git userdir repo
execute "tar zxvf #{node['class_gituser']['home_dir']}/packages/minion-git-userdir.tar.gz" do
  cwd node['class_gituser']['live_dir']
  user node['class_gituser']['user']
  group node['class_gituser']['group']
  not_if { File.directory?("#{node['class_gituser']['live_dir']}/minion-git-userdir.git") }
end
