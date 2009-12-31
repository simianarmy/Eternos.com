# $Id$

# Useful recipes that don't fit anywhere else

namespace :util do
  desc "tail rails log files"
  task :tail_logs, :roles => :app do
    run "tail -f #{shared_path}/log/#{stage}.log" do |channel, stream, data|
      puts  # for an extra line break before the host name
      puts "#{channel[:host]}: #{data}"
      break if stream == :err   
    end
  end
  
  desc "remotely console"
  task :console, :roles => :app do
    input = ''
    run "cd #{current_path} && ./script/console #{stage}" do |channel, stream, data|
      next if data.chomp == input.chomp || data.chomp == ''
      print data
      channel.send_data(input = $stdin.gets) if data =~ /^(>|\?)>/
    end
  end
end