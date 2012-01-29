require 'syslog'

class ClaSyslogHandler < Chef::Handler
  def initialize(options = {}) 
    # This throws a RuntimeError if syslog is already open
    # ignore the error, it's not useful
    begin
      Syslog.open('chef-client', 
                Syslog::LOG_PID | Syslog::LOG_NDELAY, 
                Syslog::LOG_DAEMON)
    rescue RuntimeError => e
      nil
    end
  end

  def report
    if run_status.failed? 
      pri = :err

      safe_syslog(pri, "Chef run (#{run_status.elapsed_time}) failed:")
      run_status.formatted_exception.each_line do |line|
        safe_syslog(pri, line)
      end
    else
      pri = :info
      safe_syslog(pri, "Chef run (#{run_status.elapsed_time}) updated resources:")
      run_status.updated_resources.each do |res|
        res.to_s.each_line do |line|
          safe_syslog(pri, line)
        end
      end
    end
  end

  def safe_syslog(priority, message)   
    # syslog blindly passes C format strings; escape any % signs
    message.gsub!('%', '%%')
    ## this is a bit of metaprogramming that allows some nice stuff
    ## the send command allows us to call a method named the value of
    ## the priority var, so safe_syslog(:info, msg) is the same as 
    ## Syslog.info(msg), after msg is sanitized.
    Syslog.send(priority, message)
  end
end

