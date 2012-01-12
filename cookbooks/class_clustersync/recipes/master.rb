# Dependencies
include_recipe "clustersync"
include_recipe "logrotate"

# Add cron jobs
cron "clustersync" do
  minute "*/5"
  user "root"
  command "/usr/local/scripts/push-files >> /var/log/push-files.log"
end

# Add log rotation
logrotate "clustersync" do
  files ["/var/log/push-files.log","/var/log/unison.log"]
  frequency :monthly
  rotate_count 5
  rotate_if_empty false
  missing_ok true
  compress true
end