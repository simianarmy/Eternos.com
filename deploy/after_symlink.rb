
task :symlink_shared do
  fetch(:shared_configs).each do |config|
    run "ln -nfs #{shared_path}/config/#{config} #{current_path}/config/#{config}"
  end
  
  run "mkdir -p #{shared_path}/assets"
  run "ln -nfs #{shared_path}/assets #{current_path}/public/assets"
  run "mkdir -p #{shared_path}/cloud_staging"
  run "ln -s #{shared_path}/cloud_staging #{current_path}/tmp/cloud_staging"
end

task :minify_js, :roles => [:app] do
  run "cd #{current_path} && rake js:min RAILS_ENV=#{stage}"
end