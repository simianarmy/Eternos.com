# $Id$
# Production deploy recipe
# to EngineYard slice
role :app, "184.72.228.213"
role :web, "184.72.228.213"
role :db,  "184.72.228.213", :primary => true

set :deploy_to, "/data/Eternos_www"
set :user, "deploy"
set :repository, 'git@github.com:simianarmy/Eternos.com.git'
set :scm, :git
set :branch, :master
#set :deploy_via, :remote_cache
# This will execute the Git revision parsing on the *remote* server rather than locally
set :real_revision, 			lambda { source.query_revision(revision) { |cmd| capture(cmd) } }
# comment out if it gives you trouble. newest net/ssh needs this set.
ssh_options[:paranoid] = false
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
#default_run_options[:pty] = true # required for svn+ssh:// andf git:// sometimes

namespace :deploy do
  task :more_symlink_shared, :roles => [:web] do
    run "ln -nfs #{shared_path}/config/sphinx.yml #{release_path}/config/sphinx.yml"
  end
end

before "deploy:update_code", "deploy:stop_daemons"
after "deploy:symlink_shared", "deploy:minify_js"
after "deploy:symlink", "deploy:publish_robots_file"
#after "deploy:symlink", "deploy:google_analytics"
#after "deploy:symlink", "deploy:cleanup" # Messes with backup daemons
#after "deploy:symlink", "deploy:update_crontab"

after "deploy:symlink", "deploy:symlink_shared"
after "deploy:symlink_shared", "deploy:more_symlink_shared"
#after "deploy:symlink_shared", "deploy:build_sphinx_index"
after "deploy:symlink", "deploy:start_daemons"
#after "deploy:symlink", "deploy:sendmail"
#after "deploy:symlink", "deploy:install_sitemaps"