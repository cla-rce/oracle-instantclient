search(:cla_cronjobs).each do |job|
  cron job['id'] do
    command job['command']
    user job['user'] if job.has_key?('user')
    mailto job['mailto'] if job.has_key?('mailto')
    minute job['minute'] if job.has_key?('minute')
    hour job['hour'] if job.has_key?('hour')
    day job['day'] if job.has_key?('day')
    month job['month'] if job.has_key?('month')
    weekday job['weekday'] if job.has_key?('weekday')

    if (job['server_roles'] & node['roles']).empty? or (job.has_key?('disabled') and job['disabled'])
      action :delete
    else
      action :create
    end
  end
end