#!/bin/bash

PARAM_1=$1

if [ -z "$PARAM_1" ]; then
	echo "No parameters found.  Please provide either 0 or 1"
	exit 1
fi

LOCK=/tmp/$(basename $0)-${PARAM_1}.lock
if [ -f ${LOCK} ]; then
	exit 0
fi

touch ${LOCK}
LOG_HOME=/home/st_lim/local
IDENTITY_ARRAY[0]=cuda
IDENTITY_ARRAY[1]=opencl

ETHMINER_LOG=${LOG_HOME}${PARAM_1}.log
IDENTITY=${IDENTITY_ARRAY[$PARAM_1]}
# ETHMINER_LOG=${LOG_HOME}test.log

ETHMINER_ERRORS[0]="Read response failed. End of file"
ETHMINER_ERRORS[1]="Could not resolve"
ETHMINER_ERRORS[2]="submit solution. Not connected"

exec 1> >(/usr/bin/logger -p local2.info -s -t ${IDENTITY}) 2>&1

echo "Monitoring (${IDENTITY}) - Checking (${ETHMINER_LOG})"
if [ $( dmesg | grep -c 'GPU has fallen off') -ne 0 ]; then
	systemctl reboot --force --no-wall
else
	for MYERR_COUNT in {0..2}; do
		MYERR=${ETHMINER_ERRORS[$MYERR_COUNT]}
		FOUND=$(tail -n5 $ETHMINER_LOG | grep --count "$MYERR")
		while [ ${FOUND} -gt 0 ]; do
			echo "Found (${FOUND}) instance of error message (${MYERR}) in (${ETHMINER_LOG}) - Killing (${IDENTITY})"
			systemctl restart ${IDENTITY}-farm
			sleep 2
			FOUND=$(tail -n5 $ETHMINER_LOG | grep --count "$MYERR")
		done
	done
fi
rm ${LOCK}
