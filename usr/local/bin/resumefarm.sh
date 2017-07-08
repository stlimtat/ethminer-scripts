#!/bin/bash

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
	sudo systemctl restart farm
fi
rm ${LOCK}

