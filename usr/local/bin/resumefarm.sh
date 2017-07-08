#!/bin/bash -x

ETHMINER=/usr/local/bin/ethminer
LOGFILE=/var/log/mail.log
CONNECTPATTERN=PoWhash
LOCK=/tmp/$(basename $0).lock

if [ -f ${LOCK} ]; then
	exit 0
fi

touch ${LOCK}
if [ -z "$( tail -n3 ${LOGFILE} | grep '${CONNECTPATTERN}')" ]; then
	#cat /dev/null > /var/log/mail.log
	sleep 5
	if [ -z "$( tail -n3 ${LOGFILE} | grep '${CONNECTPATTERN}')" ]; then
		sudo systemctl restart farm
	fi
fi
rm ${LOCK}

