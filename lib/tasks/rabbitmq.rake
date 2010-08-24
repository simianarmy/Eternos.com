# $Id$

# RabbitMQ rake tasks

namespace :rabbitmq do
  desc "Starts server"
  task :start_server do
    sh "sudo rabbitmq-server -detached"
  end
  
  task :setup_vhost do
    unless vhost = ENV['VHOST']
      puts "Specify vhost with VHOST= variable"
      exit
    end
    sh "sudo rabbitmqctl add_vhost /#{vhost}"
    # How to get version from shell??
    # rabbitmq 1.6
    sh "sudo rabbitmqctl set_permissions -p /#{vhost} backupd '.*' '.*' '.*'"
    sh "sudo rabbitmqctl set_permissions -p /#{vhost} bkupworker '.*' '.*' '.*'"
    # 1.5
    #sh "sudo rabbitmqctl map_user_vhost backupd /#{vhost}"
    #sh "sudo rabbitmqctl map_user_vhost bkupworker /#{vhost}"
  end
  
  task :add_users do
    sh "sudo rabbitmqctl add_user backupd b4ckUrlIF3"
    sh "sudo rabbitmqctl add_user bkupworker passpass"
  end
  
  desc "Display server status"
  task :status do
    sh "sudo rabbitmqctl status"
  end
  
  desc "Display vhost stats" 
  task :stats do
    sh "sudo rabbitmqctl list_exchanges -p /eternos"
    sh "sudo rabbitmqctl list_queues -p /eternos"
  end
end