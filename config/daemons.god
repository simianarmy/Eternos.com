# $Id: daemons.god.erb 503 2009-09-12 05:26:53Z marc $
#
# This is a configuration template for 'god' process monitoring.
#
# God config file for eternos support daemons

RAILS_ROOT  = File.dirname(File.dirname(__FILE__))
# sucks but no reliable way to get rails env from environment vars in God
# determine rails env from rails root directory name
RAILS_ENV = (RAILS_ROOT =~ /eternos.com(_\w+)/) || 'production'

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
  script = "cd #{RAILS_ROOT} && /usr/bin/env RAILS_ENV=#{RAILS_ENV} ./script/workling_client"
  w.name = "eternos-workling_#{RAILS_ENV}"
  w.group = "eternos_#{RAILS_ENV}"
  w.interval = 60.seconds
  w.start = "#{script} start"
  w.restart = "#{script} restart"
  w.stop = "#{script} stop"
  w.start_grace = 20.seconds
  w.restart_grace = 20.seconds
  w.pid_file = "#{RAILS_ROOT}/log/workling.pid"

  generic_monitoring(w, :cpu_limit => 80.percent, :memory_limit => 100.megabytes)
end

God.watch do |w|
  script = "memcached"
  w.name = "memcached"
  w.group = "eternos"
  w.interval = 60.seconds
  w.start = "#{script}"
  w.start_grace = 20.seconds
  w.restart_grace = 20.seconds
    
  generic_monitoring(w, :cpu_limit => 80.percent, :memory_limit => 100.megabytes)
end

God.watch do |w|
  script = "Xvfb"
  w.name = "Xvfb"
  w.group = "eternos"
  w.interval = 5.minutes
  w.start = "Xvfb :1 -screen 0 1024x768x24"
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



