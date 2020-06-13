#!/bin/bash

# restart Smokeping daemon
# NOTE: Smokeping actually supports the '--reload' command,
#	however, that's not currently implenented in upstreams s6
/bin/s6-svc -wr -t /var/run/s6/services/smokeping

# kill the Smokeping CGI frontend as well
/usr/bin/pkill -9 -f '/usr/bin/perl /usr/bin/smokeping_cgi /etc/smokeping/config'
