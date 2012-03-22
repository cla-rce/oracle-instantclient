case node[:platform]
when "ubuntu","debian"
  default[:cla_cacerts][:cacert_dir] = "/usr/local/share/ca-certificates"
when "redhat","centos"
  osver = node[:platform_version].to_i
  case osver
  when 5
    default[:cla_cacerts][:cacert_dir] = "/etc/pki/tls/certs"
  else
    default[:cla_cacerts][:cacert_dir] = "/etc/ssl/certs"
    Chef::Log.warn("Not tested on platform")
  end
end
