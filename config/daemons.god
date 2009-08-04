# $Id$
#
# This is a configuration template for 'god' process monitoring.
#
# God config file for eternos support daemons

RAILS_ROOT  = File.dirname(File.dirname(__FILE__))

def generic_monitoring(w, options = {})
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 10.seconds
      c.running = false
      c.notify = 'sysadmin'
    end
  end
  
  w.restart_if do |restart|
    restart.condition(:memory_usage) do |c|
      c.above = options[:memory_limit]
      c.times = [3, 5] # 3 out of 5 intervals
      c.notify = 'sysadmin'
    end
  
    restart.condition(:cpu_usage) do |c|
      c.above = options[:cpu_limit]
      c.times = 5
      c.notify = 'sysadmin'
    end
  end
  
  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 5.minute
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
      c.notify = 'sysadmin'
    end
  end
end

God.watch do |w|
  script = "RAILS_ENV='development' #{RAILS_ROOT}/script/workling_client"
  w.name = "eternos-workling"
  w.group = "eternos"
  w.interval = 60.seconds
  w.start = "#{script} start"
  w.restart = "#{script} restart"
  w.stop = "#{script} stop"
  w.start_grace = 20.seconds
  w.restart_grace = 20.seconds
  w.pid_file = "#{RAILS_ROOT}/log/workling.pid"
  
  w.behavior(:clean_pid_file)
  
  generic_monitoring(w, :cpu_limit => 80.percent, :memory_limit => 100.megabytes)
end

God.watch do |w|
  script = "#{RAILS_ROOT}/script/backup_emails_uploader.rb"
  w.name = "eternos-email-uploader"
  w.group = "eternos"
  w.interval = 60.seconds
  w.start = "RAILS_ENV='development' ruby #{script}"
  w.stop = "ps auxw|grep backup_emails_uploader | awk '{print $2}' | xargs kill -9"
  w.start_grace = 20.seconds
  w.restart_grace = 20.seconds
  
  
  generic_monitoring(w, :cpu_limit => 80.percent, :memory_limit => 100.megabytes)
end

God::Contacts::Email.server_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => "eternos.com",
  :authentication => :plain,
  :user_name => "mailer@eternos.com",
  :password => "UBy6XprJ50MhIE"
}

God.contact(:email) do |c|
  c.name = 'sysadmin'
  c.email = 'marc@eternos.com'
end



