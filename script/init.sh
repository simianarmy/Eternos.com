# Server startup script to start required non-root application services

APP_DIR=/var/www/eternos.com/current
GOD=/opt/ruby-enterprise-1.8.6-20090610/bin/god
RAKE=/opt/ruby-enterprise-1.8.6-20090610/bin/rake
export RAILS_ENV=production

# Rails app
# Start god & load god config
echo "$GOD load $APP_DIR/config/daemons.god"
$GOD load $APP_DIR/config/daemons.god
echo "$GOD monitor eternos_production" 
$GOD monitor eternos_production

# Start Sphinx
echo "cd $APP_DIR && $RAKE ts:start"
cd $APP_DIR && $RAKE ts:start

