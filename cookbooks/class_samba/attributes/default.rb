default["class_samba"]["workgroup"] = "class_samba"
default["class_samba"]["interfaces"] = "lo 127.0.0.1"
default["class_samba"]["hosts_allow"] = "127.0.0.0/8"
default["class_samba"]["bind_interfaces_only"] = "no"
default["class_samba"]["server_string"] = "Samba Server"
default["class_samba"]["load_printers"] = "no"
default["class_samba"]["passdb_backend"] = "tdbsam"
default["class_samba"]["dns_proxy"] = "no"
default["class_samba"]["security"] = "user"
default["class_samba"]["socket_options"] = "TCP_NODELAY"

case platform
when "arch"
  set["class_samba"]["config"] = "/etc/samba/smb.conf"
  set["class_samba"]["log_dir"] = "/var/log/samba/log.%m"
when "redhat","centos","fedora","scientific"
  set["class_samba"]["config"] = "/etc/samba/smb.conf"
  set["class_samba"]["log_dir"] = "/var/log/samba/log.%m"
else
  set["class_samba"]["config"] = "/etc/samba/smb.conf"
  set["class_samba"]["log_dir"] = "/var/log/samba/%m.log"
end

#
# CLASS-OAD additions
#

# socket buffer optimizations
default["class_samba"]["socket_options"] = "TCP_NODELAY SO_RCVBUF=8192 SO_SNDBUF=8192"

# require NTLMv2 authentication
default["class_samba"]["client_ntlmv2_auth"] = "yes"

# require NT protocol
default["class_samba"]["min_protocol"] = "NT1"

# prevent enumeration of shares to anonymous users
default["class_samba"]["restrict_anonymous"] = 2

# standard hostname resolution
default["class_samba"]["name_resolve_order"] = "host"

# disable printing
default["class_samba"]["printing"] = "bsd"
default["class_samba"]["printcap_name"] = "/dev/null"
default["class_samba"]["disable_spoolss"] = "yes"

# don't try to become a master server
default["class_samba"]["domain_master"] = "no"
default["class_samba"]["local_master"] = "no"
default["class_samba"]["preferred_master"] = "no"

# disable lanman broadcasts
default["class_samba"]["lm_announce"] = "no"

# disable netbios broadcasts (be sure to disable nmbd service)
default["class_samba"]["disable_netbios"] = "yes"

