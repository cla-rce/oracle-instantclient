include_recipe "apache2::default"

current_vhosts = Array.new
enabled_vhosts = Hash.new
enabled_addrs = Array.new
enabled_ports = Array.new
ssl_certs = Hash.new

class_data_bag_secret = File.open(node['class_vhosts']['secret_path']).read

# get the currently enabled vhosts
if File.directory?("#{node[:apache][:dir]}/sites-enabled/")
  Dir.entries("#{node[:apache][:dir]}/sites-enabled/").each do |f|
    if File.symlink?("#{node[:apache][:dir]}/sites-enabled/#{f}")
      current_vhosts << (f == "000-default" ? "default" : f)
    end
  end
end

# create ssl directories (if they don't already exist)
%w{ crt key }.each do |dir|
  directory "#{node[:apache][:dir]}/ssl/#{dir}" do
    owner "root"
    group "root"
    mode 0644
    recursive true
  end
end

# generate vhosts from data bags
search(:class_vhosts).each do |vhost|
  if not (vhost['server_roles'] & node['roles']).empty?
    if vhost.has_key?('default_site') and not (vhost['default_site'] & node['roles']).empty?
      vhost_name = "default"
    else
      vhost_name = vhost['id']
    end

    vhost['vhosts'].each do |p,vh|
      # generate ssl certificate/key files
      %w{ SSLCertificate SSLCertificateChain }.each do |type|
        if vh.has_key?(type)
          cert = Chef::EncryptedDataBagItem.load("certs", vh[type], class_data_bag_secret).to_hash

          file "#{node[:apache][:dir]}/ssl/crt/#{cert['name']}.crt" do
            owner "root"
            group "root"
            mode 0644
            content cert['cert']
          end

          if cert.has_key?('key')
            file "#{node[:apache][:dir]}/ssl/key/#{cert['name']}.key" do
              owner "root"
              group "root"
              mode 0644
              content cert['key']
            end
          end
        
          ssl_certs[vh[type]] = cert['name']
        end
      end
      
      # add the vhost addr to the enabled_addrs array
      enabled_addrs << p
      
      # add the vhost port to the enabled_ports array
      enabled_ports << p.gsub(/^.*?:/, '')
    end

    # add to enabled_vhosts hash
    enabled_vhosts[vhost_name] = vhost
  end
end

# generate class_vhosts_ports file
template "#{node[:apache][:dir]}/conf.d/class_vhosts_ports.conf" do
  source "ports.erb"
  owner "root"
  group "root"
  mode 0644
  variables(:addrs => enabled_addrs.uniq, :ports => enabled_ports.uniq)
end

# generate sites-available files for each vhost
enabled_vhosts.each do |vhost_name,vhost|
  template "#{node[:apache][:dir]}/sites-available/#{vhost_name}" do
    source "vhost.erb"
    owner "root"
    group "root"
    mode 0644
    variables(:vhost => vhost, :ssl_certs => ssl_certs)
  end

  # enable the vhost
  apache_site vhost_name
end

# disable any vhosts that are no longer enabled
(current_vhosts - enabled_vhosts.keys).each do |site|
  apache_site site do
    enable false
  end
end
