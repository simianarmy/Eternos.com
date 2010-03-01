#!/bin/bash
#
# God
#
# chkconfig: - 85 15
# description: start, stop, restart God
#

GOD=/opt/ruby-enterprise-1.8.6-20090610/bin/god
RETVAL=0

case "$1" in
    start)
      $GOD -P /var/run/god.pid -l /var/log/god.log
      $GOD load /etc/god.conf
      RETVAL=$?
  ;;
    stop)
      kill `cat /var/run/god.pid`
      RETVAL=$?
  ;;
    restart)
      kill `cat /var/run/god.pid`
      $GOD -P /var/run/god.pid -l /var/log/god.log
      $GOD load /etc/god.conf
      RETVAL=$?
  ;;
    status)
      RETVAL=$?
  ;;
    *)
      echo "Usage: god {start|stop|restart|status}"
      exit 1
  ;;
esac

exit $RETVAL
~