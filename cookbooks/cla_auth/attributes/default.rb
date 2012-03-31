default[:cla_auth][:ldap_base] = "ou=People,o=University of Minnesota,c=US"
default[:cla_auth][:ldap_servers] = [ "ldaps://ldapauth.umn.edu" ]
default[:cla_auth][:mkey_radius_secret] = "Wb!gy81qern9xe#2"
default[:cla_auth][:mkey_radius_hosts] = %w{ 192.168.110.225:1645 192.168.110.226:1645 192.168.110.227:1645 }
case platform
when "ubuntu"
  default[:cla_auth][:ldap_cacert_fname] = "ca-certificates.crt"
when "redhat", "centos"
  default[:cla_auth][:ldap_cacert_fname] = "ca-bundle.crt"
end
