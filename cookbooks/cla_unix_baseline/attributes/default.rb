default[:cla_unix_baseline][:disable_apparmor] = false
default[:cla_unix_baseline][:syslog_servers] = ["160.94.120.97", "192.168.53.46"]
default[:cla_unix_baseline][:base_ppa] = "ppa:buysse/umn"
default[:cla_unix_baseline][:use_system_proxy] = false
default[:cla_unix_baseline][:system_proxy] = "http://labproxy.cla.umn.edu:3128"
default[:cla_unix_baseline][:proxy_ignore_domains] = ""