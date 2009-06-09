#!/bin/sh
# $Id$
#
# Setup script to create testing environment on localhost for Facebook Connect
# Facebook Connect uses a callback URL pointing to staging.eternos.com

# Usage: sudo host_change.sh local|staging
# 	setup: creates required alternate hosts files from original
# 	local: staging.eternos.com will hit staging server
#		staging: staging.eternos.com will hit localhost

if [ "$1" == setup ]
	then
	cp /etc/hosts /etc/hosts.bak
	cp /etc/hosts /etc/hosts.local
	cp /etc/hosts /etc/hosts.staging 
	echo "127.0.0.1	staging.eternos.com" >> /etc/hosts.staging
else
	cp /etc/hosts /etc/hosts.bak
	cp /etc/hosts.$1 /etc/hosts
fi