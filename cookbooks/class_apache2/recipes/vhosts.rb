include_recipe "class_apache2::default"

current_vhosts = Array.new
enabled_vhosts = Hash.new
enabled_addrs = Array.new
enabled_ports = Array.new
ssl_certs = Hash.new

class_data_bag_secret = File.open(node[:class_apache][:secret_path]).read

# get the currently enabled vhosts
if File.directory?("#{node[:apache][:dir]}/sites-enabled/")
  Dir.entries("#{node[:apache][:dir]}/sites-enabled/").each do |f|
    if File.symlink?("#{node[:apache][:dir]}/sites-enabled/#{f}")
      current_vhosts << (f == "000-default" ? "default" : f)
    end
  end
end

# generate vhosts from data bags
search(:class_vhosts).each do |class_vhost|
  if not (class_vhost['server_roles'] & node['roles']).empty?
    vhost = class_vhost.clone

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
              mode 0600
              content cert['key']
            end
          end
        
          ssl_certs[vh[type]] = cert['name']
        end
      end
      
      # UseServerName: Rewrites/redirects requests from a ServerAlias URL to the main ServerName URL.
      if vh.has_key?("UseServerName")
        usn = Array.new

        usn << "RewriteEngine on"
        usn << "RewriteCond %{HTTP_HOST} !^#{Regexp.quote(vh['ServerName'])} [NC]"
        usn << "RewriteRule ^(.*)$ #{vh.has_key?("SSLCertificate") ? "https" : "http"}://#{vh['ServerName']}$1 [L,R=301]"

        vhost['vhosts'][p]['RewriteUSN'] = usn
        vhost['vhosts'][p].delete("UseServerName")
      end

      # Crimson CommID: Rewrites all requests to /index.php?comm_id=x
      if vh.has_key?("CommID")
        crimson = Array.new

        crimson << "RewriteEngine on"
        crimson << "Alias /crimson/ /data/www/htdocs/crimson/"
        crimson << "RewriteCond %{REQUEST_URI} !^/crimson/"
        
        # exclude home directories if UserDir is set
        if vh.has_key?("UserDir")
          crimson << "RewriteCond %{REQUEST_URI} !^/~"
        end
        
        # exclude crimson admin urls if using SSL
        if vh.has_key?("SSLCertificate")
          crimson << "Alias /crimsonAdmin/ /data/www/crimson/"
          crimson << "RewriteCond %{REQUEST_URI} !^/crimsonAdmin/"
        end

        # exclude aliases and redirects from being pointed to crimson
        %w{ Alias Redirect }.each do |cfg|
          if vh.has_key?(cfg)
            vh[cfg].each do |k,v|
              crimson << "RewriteCond %{REQUEST_URI} !^#{Regexp.quote(k)}"
            end
          end
        end

        crimson << "RewriteRule ^(.+) /index.php?comm_id=#{vh['CommID']}&req=$1 [L,QSA]"

        vhost['vhosts'][p]['RewriteCommID'] = crimson
        vhost['vhosts'][p].delete("CommID")
      end
      
      # add additional listen ports to the enabled_ports and enabled_addrs arrays
      ( vhost_addr, vhost_port ) = p.split(/:/)
      
      if not node[:apache][:listen_ports].include? vhost_port
        # add the port to the enabled_ports array
        enabled_ports << vhost_port
      end
      
      if vhost_addr != "*" or not node[:apache][:listen_ports].include? vhost_port
        # add the addr to the enabled_addrs array
        enabled_addrs << p
      end
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
