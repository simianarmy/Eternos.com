on_app_servers do
  run "echo 'rake js:min' >> #{shared_path}/logs.log"
  run "cd #{release_path} && RAILS_ENV=#{environment} rake js:min"
  sudo "monit restart memcache_11211"
end