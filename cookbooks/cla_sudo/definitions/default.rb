define :cla_sudo_commands, :commands => [], :allowed_group => "sysadmin", :target_user => "root" do 
  template "/etc/sudoers.d/cla_sudo_#{params[:name]}" do 
    source "cla_sudo_commands.erb"
    owner "root"
    group "root"
    mode "0440"
    variables(:params => params)
  end
end

