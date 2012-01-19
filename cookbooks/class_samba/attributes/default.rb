default["class_samba"]["workgroup"] = "class_samba"
default["class_samba"]["interfaces"] = "lo 127.0.0.1"
default["class_samba"]["hosts_allow"] = "127.0.0.0/8"
default["class_samba"]["bind_interfaces_only"] = "no"
default["class_samba"]["server_string"] = "Samba Server"
default["class_samba"]["load_printers"] = "no"
default["class_samba"]["passdb_backend"] = "tdbsam"
default["class_samba"]["dns_proxy"] = "no"
default["class_samba"]["security"] = "user"
default["class_samba"]["map_to_guest"] = "Bad User"
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

# added by CLASS-OAD
default["class_samba"]["local_master"] = "no"
default["class_samba"]["unix_password_sync"] = "yes"
default["class_samba"]["pam_password_change"] = "yes"
default["class_samba"]["wide_links"] = "no"
default["class_samba"]["restrict_anonymous"] = 2
default["class_samba"]["printing"] = "bsd"
default["class_samba"]["printcap_name"] = "/dev/null"
default["class_samba"]["disable_spoolss"] = "yes"
