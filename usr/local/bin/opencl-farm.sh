#!/bin/sh -x

GETH=/usr/bin/geth
ETHMINER=/usr/local/bin/ethminer
MYCMD=${0}
IDENTITY=$( basename ${MYCMD} | sed -e 's/-farm.sh//' )

export GPU_FORCE_64BIT_PTR=0
export GPU_MAX_HEAP_SIZE=100
export GPU_USE_SYNC_OBJECTS=1
export GPU_MAX_ALLOC_PERCENT=100
export GPU_SINGLE_ALLOC_PERCENT=100
exec 1> >(/usr/bin/logger -p mail.info -s -t $(basename $0)) 2>&1

start() {
	lshw -c video | grep "bus info:"
	$ETHMINER --list-devices
	sudo -s -u st_lim \
		$ETHMINER --farm-recheck 200 \
		--verbosity 7 \
		-S asia1.ethermine.org:4444 \
		-FS asia1.ethermine.org:14444 \
		--stratum-email st_lim\@stlim.net \
		--userpass a04954b34a5d54715b03d732caa9bc05ef4d6df5.stlimeth \
		-G --opencl-platform 1 --opencl-devices 3
}

stop() {
	# Identify the cuda only ethminer
	ETHMINER_PID=$(/bin/ps -eww f | grep ethminer | grep ${IDENTITY} | awk '{ print $1 }')
	FARM_PID=$(/bin/ps -eww f | grep ${IDENTITY}-farm | grep start | awk '{ print $1 }')
	kill -9 $ETHMINER_PID
	kill -9 $FARM_PID
	sleep 10
}

reload() {
	stop
	start
}

bench() {
	sudo -s -u st_lim \
		$ETHMINER -U -M
}


case $1 in
	start|stop|reload|bench) "$1";;
esac
