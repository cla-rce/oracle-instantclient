define :classadm_commands, :commands => [] do
  template "/etc/sudoers.d/classadm-#{params[:name]}" do
    source "classadm.sudoers.erb"
    owner "root"
    group "root"
    mode "0440"
    variables(:params => params)
  end
end