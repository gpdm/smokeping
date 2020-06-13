#!/bin/bash

# activate verbose logging if SPMONITOR_VERBOSE is set
[ ! -z "${SPMONITOR_VERBOSE}" ] && exec >/var/log/nfs-changenotifier.log

# check if /config is mounted from NFS
mount | grep 'on /config type nfs' > /dev/null

if [ "$?" = "1" ]; then

	echo "/config not mounted via NFS, disabling NFS monitor."
	s6-svc -k -wd -d /var/run/s6/services/nfs-changenotifier
	exit 0

else

	echo "/config mounted via NFS. Will monitor for changes..."

	# get initial mdsum on /config dir
	sumPrev=`tar -cpf- /config 2>/dev/null | md5sum`
	
	while [ : ]; do
	        # refresh current mdsum on /config dir
		sumCur=`tar -cpf- /config 2>/dev/null | md5sum`
	
	        # reload smokeping on config  change
	        if [ "${sumPrev}" != "${sumCur}" ]; then
	                echo "`date`: config change detected. reloading smokeping..."
	                sumPrev=${sumCur}
			/usr/bin/smokeping-restart.sh
		else
	                echo "`date`: no config changes detected."
	        fi
	
	        sleep 60
	done

fi
