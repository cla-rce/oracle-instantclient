include_recipe "apache2"

current_vhosts = Array.new
enabled_vhosts = Array.new
ssl_certs = Hash.new

class_data_bag_secret = File.open(node['vhosts']['secret_path']).read

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
search(:vhosts).each do |vhost|
  if not (vhost['server_roles'] & node['roles']).empty?
    if vhost.has_key?('default_site') and not (vhost['default_site'] & node['roles']).empty?
      vhost_name = "default"
    else
      vhost_name = vhost['id']
    end

    # generate ssl certificate/key files
    vhost['vhosts'].each do |p,vh|
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
    end

    # generate sites-available file
    template "#{node[:apache][:dir]}/sites-available/#{vhost_name}" do
      source "vhost.erb"
      owner "root"
      group "root"
      mode 0644
      variables(:vhost => vhost, :ssl_certs => ssl_certs)
    end
    
    # enable the vhost
    apache_site vhost_name

    enabled_vhosts << vhost_name
  end
end

# disable any vhosts that are no longer enabled
(current_vhosts - enabled_vhosts).each do |site|
  apache_site site do
    enable false
  end
end