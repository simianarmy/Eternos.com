#!/bin/bash

DELAY=2

while getopts whp: option_read
do
    case $option_read in
        h)  HELP=1
        ;;  
        p)  DELAY=$OPTARG
            echo $DELAY | egrep -v [a-z] | egrep -v [A-Z] ||
                HELP=1
        ;;  
        w)  W3M=1
        ;;  
    esac
done

if [ "$HELP" = 1 ]; then
    cat <<EOH

This program continuously monitors mysql queries.

    -p Pause for x seconds (2 is default).  Must be numeric.

    -w Uses w3m to print a beautified version.  Basically 
       displays the query 

    -h Print help menu

EOH
    exit
fi

cmd="mysqladmin processlist -uprocess"
[ $W3M ] && cmd="mysql -A -H -e 'show processlist' | w3m -dump -T text/html"

/usr/bin/watch -n $DELAY "$cmd"