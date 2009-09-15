# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :cron_log, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :cron_log, "#{RAILS_ROOT}/log/cron.log"

rake_opts = '--trace'

every 1.day, :at => "2am" do
  rake "#{rake_opts} backup:publish_jobs"
end

every 1.day do
  rake "#{rake_opts} backup:generate_report"
end

every 1.hour do
  rake "#{rake_opts} backup:download_photos"
end

every :saturday, :at => "4am" do
  command "rm -rf #{RAILS_ROOT}/tmp/cache"
end