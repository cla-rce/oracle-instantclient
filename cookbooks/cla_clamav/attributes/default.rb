default[:cla_clamav][:email_to] = "servers@rt.cla.umn.edu"
# valid options are daily, weekly, monthly, quarterly, yearly
default[:cla_clamav][:run_frequency] = "weekly"
# array of excluded paths on local host
default[:cla_clamav][:exclude_dirs] = []
# ignore larger files for speed
default[:cla_clamav][:max_filesize] = "1M"
# allow setting a nice value for the process
# blank is no nicing
default[:cla_clamav][:nice_value] = "10"
