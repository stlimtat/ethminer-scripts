#!/bin/bash -x

ETHMINER_ARCH=$1

if [ -z "$ETHMINER_ARCH" ]; then
	echo "No parameters found.  Please provide either 0 or 1"
	exit 1
fi

LOCK=/tmp/$(basename $0)-${ETHMINER_ARCH}.lock
if [ -f ${LOCK} ]; then
	exit 0
fi

touch ${LOCK}
LOG_HOME=/home/st_lim/local
ETHMINER_LOG_ARRAY[0]=${LOG_HOME}0.log
ETHMINER_LOG_ARRAY[1]=${LOG_HOME}1.log
ETHMINER_INSTANCE_ARRAY[0]=cuda
ETHMINER_INSTANCE_ARRAY[1]=opencl

ETHMINER_LOG=${ETHMINER_LOG_ARRAY[$ETHMINER_ARCH]}
ETHMINER_INSTANCE=${ETHMINER_INSTANCE_ARRAY[$ETHMINER_ARCH]}
ETHMINER_LOG=${LOG_HOME}test.log

ETHMINER_ERRORS[0]="Read response failed: End of file"
ETHMINER_ERRORS[1]="Could not resolve"
ETHMINER_ERRORS[2]="submit solution: Not connected"

if [ $( dmesg | grep -c 'GPU has fallen off') -ne 0 ]; then
	sudo systemctl reboot --force --no-wall
else
	for MYERR_COUNT in {0..2}; do
		MYERR=${ETHMINER_ERRORS[$MYERR_COUNT]}
		FOUND=$(tail -n5 $ETHMINER_LOG | grep "$MYERR" | wc -l)
		if [ -n ${FOUND} ]; then
			echo "Found (${FOUND}) instance of error message (${MYERR}) in (${ETHMINER_LOG}) - Killing (${ETHMINER_INSTANCE})"
			while [ -n ${FOUND} ]; do
				systemctl restart ${ETHMINER_INSTANCE}-farm
				sleep 10
				FOUND=$(tail -n5 $ETHMINER_LOG | grep "$MYERR" | wc -l)
			done
		fi
	done
fi
rm ${LOCK}
