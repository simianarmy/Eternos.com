# $Id$
set :application, "eternos"
set :domain, "#{application}.com"
set :svn_user, ENV['svn_user'] || "marc"
set :svn_password, ENV['svn_password'] || Proc.new { Capistrano::CLI.password_prompt('SVN Password: ') }
set :repository,
  Proc.new { "--username #{svn_user} " +
             "--password #{svn_password} " +
             "--no-auth-cache " + 
             "--non-interactive " + 
             "https://eternos.unfuddle.com/svn/eternos_www/trunk" }
             
# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:

set :scm, 'subversion'

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "72.3.253.143"
role :web, "72.3.253.143"
role :db,  "72.3.253.143", :primary => true

set :stages, %w(development staging production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

ssh_options[:paranoid] = false
default_run_options[:pty] = true
set :user, "mmauger"            # defaults to the currently logged in user
set :use_sudo, false
set :deploy_via, :remote_cache
set :keep_releases, 3
set :dos2unix, "/usr/bin/dos2unix"

namespace :deploy do
  task :start do
    # do nothing - override default
  end
  
  desc "Restart web server"
  task :restart, :roles => :web do
    run "cd #{current_path} && rake RAILS_ENV=#{stage} tmp:cache:clear"
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  desc "Symlink shared configs and folders on each release."
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/assets #{release_path}/public/assets"
    # Setup permissions so that designer can read/write in view directories
    run "chgrp -R www #{release_path}"
    run "chmod -R 770 #{release_path}"
    run "chmod 775 #{release_path} #{release_path}/app"
    run "chgrp -R www-dev #{release_path}/public #{release_path}/app/views"
    run "chmod -R 775 #{release_path}/public #{release_path}/app/views"
  end
  
  desc "migrate database"
  task :migrate do
    run "cd #{current_path} && rake RAILS_ENV=#{stage} db:auto:migrate" 
  end
  
  desc "Custom actions for setup"
  task :after_setup do
    run "mkdir -p #{shared_path}/assets"
  end

  desc "Stops work daemons"
  task :stop_daemons, :roles => :app do
    run "god unmonitor eternos"
    run "god stop eternos-email-uploader"
    run "god stop eternos-workling"
  end
  
  desc "Restarts any work daemons"
  task :start_daemons, :roles => :app do
    run "cd #{current_path} && rake god:generate RAILS_ENV=#{stage}"
    run "god load #{current_path}/config/daemons.god"
    run "god restart eternos"
  end
  
  task :build_native do
    rake = fetch(:rake, 'rake')
    run "cd #{current_path}; #{sudo} #{rake} gems:build"
  end
  
  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{current_path} && whenever -s environment=#{stage} --update-crontab #{application}"
  end

  desc "Update local Google Analytics files"
  task :google_analytics, :role => :web do
    run "cd #{current_path} && rake google_analytics:update RAILS_ENV=#{stage}"
  end
  
  desc "Send email notification to dev@eternos.com"
  task :sendmail, :roles => :app do
    run "mkdir -p #{current_path}/tmp/emails"
    stime = (Date.today-1).strftime('%Y-%m-%d 23:59:59')
    #etime = Time.now.strftime('%Y-%m-%d 23:59:59')
    fname = "svn_#{rand Time.now.to_i}.txt"
    path_to_filename = "#{current_path}/tmp/emails/#{fname}"
    
    run "#{source.log('{\''+stime+'\'}', 'HEAD')} > #{path_to_filename}"
    run "cd #{current_path}; ruby script/mail_deploy_log.rb #{fname} #{stage}"
    run "rm #{path_to_filename}"
  end

end

#after "deploy:symlink", "deploy:google_analytics"
after "deploy:symlink", "deploy:cleanup"
after "deploy:symlink", "deploy:sendmail"
after "deploy:symlink", "deploy:update_crontab"
after "deploy:symlink", "deploy:symlink_shared"
after "deploy:symlink", "deploy:start_daemons"
before "deploy:update_code", "deploy:stop_daemons"




