# Server startup script to start required non-root application services

APP_DIR=/var/www/eternos.com/current
RAKE=/opt/ruby-enterprise-1.8.6-20090610/bin/rake
export RAILS_ENV=production

# Rails app
# Start Sphinx
echo "cd $APP_DIR && $RAKE ts:start"
cd $APP_DIR && $RAKE ts:start

