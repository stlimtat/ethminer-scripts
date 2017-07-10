#!/bin/bash -x

ETHMINER=/usr/local/bin/ethminer
LOGFILE=/var/log/mail.log
CONNECTPATTERN=PoWhash
CUDA_ERROR=CUDA error
CONNECT_ERROR=hostasia1
LOCK=/tmp/$(basename $0).lock

if [ -f ${LOCK} ]; then
	exit 0
fi

touch ${LOCK}
if [ $( dmesg | grep -c 'GPU has fallen off') -ne 0 ]; then
	sudo systemctl reboot --force --no-wall
elif [ $( tail -n100 ${LOGFILE} | grep -c ${CUDA_ERROR}) -ne 0 ]; then
	sudo systemctl restart farm
elif [ $( tail -n3 ${LOGFILE} | grep -c ${CONNECT_ERROR}) -ne 0 ]; then
	sudo systemctl restart farm
elif [ $( tail -n3 ${LOGFILE} | grep -c ${CONNECTPATTERN}) -lt 1 ]; then
	#cat /dev/null > /var/log/mail.log
	sleep 5
	if [ $( tail -n3 ${LOGFILE} | grep -c ${CONNECTPATTERN}) -lt 1 ]; then
		sudo systemctl restart farm
	fi
fi
rm ${LOCK}

