on_app_servers do
  run "echo 'rake js:min' >> #{shared_path}/logs.log"
  run "cd #{release_path} && bundle exec rake js:min"
  sudo "monit restart memcache_11211"
end