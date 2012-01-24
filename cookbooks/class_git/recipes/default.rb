# install git from package
case node[:platform]
when "debian", "ubuntu"
  # install git-core ppa
  apt_repository "git-core" do
    uri "http://ppa.launchpad.net/git-core/ppa/ubuntu"
    distribution node['lsb']['codename']
    components ["main"]
    keyserver "keyserver.ubuntu.com"
    key "E1DF1F24"
    action :add
  end

  # install git and git manpages
  %w{ git-core git-doc }.each do |pkg|
    package pkg do 
      action [:install, :upgrade]
    end
  end
else
  package "git" do
    action [:install, :upgrade]
  end
end

# install git bash completion
package "bash-completion"
cookbook_file "/etc/bash_completion.d/git" do
  source "git-completion.bash"
  mode "0644"
  action :create_if_missing
end
