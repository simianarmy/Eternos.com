# $Id$
# Production deploy recipe
# to EngineYard slice
role :app, "184.72.228.213"
role :web, "184.72.228.213"
role :db,  "184.72.228.213", :primary => true

set :deploy_to, "/data/Eternos_www"
set :user, "deploy"

# comment out if it gives you trouble. newest net/ssh needs this set.
ssh_options[:paranoid] = false
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
#default_run_options[:pty] = true # required for svn+ssh:// andf git:// sometimes

desc "Restart web server"
deploy.task :restart, :roles => :web do
  sudo "monit restart memcache_11211"
  sudo "/etc/init.d/nginx reload"
end

before "deploy:update_code", "deploy:stop_daemons"
after "deploy:symlink_shared", "deploy:minify_js"
after "deploy:symlink", "deploy:publish_robots_file"
#after "deploy:symlink", "deploy:google_analytics"
#after "deploy:symlink", "deploy:cleanup" # Messes with backup daemons
#after "deploy:symlink", "deploy:update_crontab"

after "deploy:symlink", "deploy:symlink_shared"

#after "deploy:symlink_shared", "deploy:build_sphinx_index"
after "deploy:symlink", "deploy:start_daemons"
#after "deploy:symlink", "deploy:sendmail"
#after "deploy:symlink", "deploy:install_sitemaps"