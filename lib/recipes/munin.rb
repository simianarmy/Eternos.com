# $Id$

# Cap recipes for Munin software

namespace :munin do
  task :install_mysql do
    cmds =<<INSTALL
    cd /usr/local/src
    git clone git://github.com/kjellm/munin-mysql.git
    cd munin-mysql
    make install
INSTALL
    sudo cmds
  end
end