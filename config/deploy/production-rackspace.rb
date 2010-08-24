# $Id$
# Production deploy recipes

set :deploy_to, "/var/www/#{domain}"
set :user, "deploy" 
set :repository, 'git@github.com:simianarmy/Eternos.com.git'
set :scm, :git
set :branch, :master
set :deploy_via, :remote_cache

#role :app, "72.3.253.143"
role :app, "184.106.217.211"
#role :web, "72.3.253.143"
role :web, "184.106.217.211"
#role :db,  "72.3.253.143", :primary => true
role :db, "184.106.217.211", :primary => true

#before "deploy:update_code", "deploy:stop_daemons"
#after "deploy:symlink_shared", "deploy:minify_js"
after "deploy:symlink", "deploy:publish_robots_file"
#after "deploy:symlink", "deploy:google_analytics"
#after "deploy:symlink", "deploy:cleanup" # Messes with backup daemons
#after "deploy:symlink", "deploy:update_crontab"

after "deploy:symlink", "deploy:symlink_shared"
#after "deploy:symlink_shared", "deploy:build_sphinx_index"
#after "deploy:symlink", "deploy:start_daemons"
#after "deploy:symlink", "deploy:sendmail"
#after "deploy:symlink", "deploy:install_sitemaps"