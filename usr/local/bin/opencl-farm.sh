#!/bin/sh -x

GETH=/usr/bin/geth
ETHMINER=/usr/local/bin/ethminer
CLAYMORE=/home/st_lim/src/claymore/ethdcrminer64

export GPU_FORCE_64BIT_PTR=0
export GPU_MAX_HEAP_SIZE=100
export GPU_USE_SYNC_OBJECTS=1
export GPU_MAX_ALLOC_PERCENT=100
export GPU_SINGLE_ALLOC_PERCENT=100
exec 1> >(/usr/bin/logger -p mail.info -s -t $(basename $0)) 2>&1

start() {
	#${GETH} --rpc \
	#	--rpcaddr 127.0.0.1 \
	#	--rpcport 8545 \
	#	--rpccorsdomain "http://localhost:3000"
	##############################
	# Ethpool
	##############################
	#	-S asia1.ethpool.org:3333 \
	#	-FS us1.ethpool.org:3333 \
	##############################
	# Ethpool
	##############################
	#/bin/bash /usr/local/bin/nvidia-overclock.sh start
	#sleep 5
	lshw -c video | grep "bus info:"
	$ETHMINER -G --list-devices
	sudo -s -u st_lim \
		$ETHMINER --farm-recheck 200 \
		--verbosity 7 \
		-S asia1.ethermine.org:4444 \
		-FS asia1.ethermine.org:14444 \
		--stratum-email st_lim\@stlim.net \
		--userpass a04954b34a5d54715b03d732caa9bc05ef4d6df5.stlimeth \
		-G --opencl-platform 1

#		-U --cuda-parallel-hash 4 \
#		-X --opencl-platform 1 \
#	sudo -s -u st_lim \
#		$CLAYMORE \
#		-epool asia1.ethermine.org:4444 \
#		-ewal "a04954b34a5d54715b03d732caa9bc05ef4d6df5.stlimeth" \
#		-epsw x \
#		-mode 1 \
#		-r 60 \
#		-colors 0
}

stop() {
	killall -9 ethminer
	if [ $( dmesg | grep -c 'GPU has fallen off') -ne 0 ]; then
		systemctl reboot --force --no-wall
	fi
	KILLED=$( ps -ef | grep ethminer | grep defunct )
	COUNT=0
	while [ -n "${KILLED}" ]; do
		kill -HUP $(ps -A -ostat,ppid | grep -e '[zZ]'| awk '{ print $2 }')
		killall -9 ethminer
		COUNT=$(($COUNT + 1))
		if [ ${COUNT} -gt 5 ]; then
			systemctl reboot --force --no-wall
		fi
		sleep 10 
		KILLED=$( ps -ef | grep ethminer | grep -v grep)
	done
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
