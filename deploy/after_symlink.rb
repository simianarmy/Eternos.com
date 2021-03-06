SharedConfigs = %w[ amazon_s3.yml amqp.yml amqp-backup.yml application.yml database.yml email.yml 
  facebooker.yml facebooker_desktop.yml facebook.vault.yml gateway.yml linkedin.yml key.yml 
  paypal.yml sphinx.yml twitter_oauth.yml workling.yml ]

on_app_servers do
  SharedConfigs.each do |config|
    run "ln -nfs #{shared_path}/config/#{config} #{release_path}/config/#{config}"
  end
  
  run "mkdir -p #{shared_path}/assets"
  run "ln -nfs #{shared_path}/assets #{release_path}/public/assets"
  run "mkdir -p #{shared_path}/cloud_staging"
  run "ln -s #{shared_path}/cloud_staging #{release_path}/tmp/cloud_staging"
end
