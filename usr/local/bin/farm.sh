#!/bin/bash -x

PARAM_1=$1
if [ -z "${PARAM_1}" ]; then
	echo "Please specify 0 for cuda, 1 for opencl farming"
	exit 1
fi

GETH=/usr/bin/geth
ETHMINER=/usr/local/bin/ethminer
VERBOSITY=1
IDENTITY_ARRAY[0]=cuda
IDENTITY_ARRAY[1]=opencl
IDENTITY=${IDENTITY_ARRAY[$PARAM_1]}

export GPU_FORCE_64BIT_PTR=0
export GPU_MAX_HEAP_SIZE=100
export GPU_USE_SYNC_OBJECTS=1
export GPU_MAX_ALLOC_PERCENT=100
export GPU_SINGLE_ALLOC_PERCENT=100
exec 1> >(/usr/bin/logger -p local${PARAM_1}.info -s -t ${IDENTITY}) 2>&1

start() {
	lshw -c video | grep "bus info:"
	if [ "${PARAM_1}" -eq "0" ]; then
		start_cuda
	else
		start_opencl
	fi
}

start_cuda() {
	LIST_DEVICES=$($ETHMINER --list-devices -U | grep --text "^\[[0-9]\]" | sed -e 's/^\[\([0-9]\)\].*/\1/' | xargs)
	if [ "$LIST_DEVICES" == "" ]; then
		echo "No devices found"
		$ETHMINER --list-devices -U
		exit 1
	fi
	sudo -s -u st_lim \
		$ETHMINER --farm-recheck 2000 \
		--verbosity $VERBOSITY \
		-S asia1.ethermine.org:4444 \
		-FS asia1.ethermine.org:14444 \
		--stratum-email st_lim\@stlim.net \
		--userpass a04954b34a5d54715b03d732caa9bc05ef4d6df5.stlimeth \
		-U --cuda-parallel-hash 8 --cuda-devices ${LIST_DEVICES}
}

start_opencl() {
	LIST_DEVICES=$($ETHMINER --list-devices -G | grep --text "^\[[0-9]\]" | grep --text -v "GeForce" | sed -e 's/^\[\([0-9]\)\].*/\1/' | xargs )
	if [ "$LIST_DEVICES" == "" ]; then
		echo "No devices found"
		$ETHMINER --list-devices -G
		exit 1
	fi
	# For Radeon
	for i in {0..3}; do
		if [ -e /sys/class/drm/card${i}-DP-1 ]; then
			echo 10 > /sys/class/drm/card${i}/device/pp_mclk_od
			echo 5 > /sys/class/drm/card${i}/device/pp_sclk_od
			cat /sys/class/drm/card${i}/device/pp_dpm_mclk
			cat /sys/class/drm/card${i}/device/pp_dpm_pcie
			cat /sys/class/drm/card${i}/device/pp_dpm_sclk
			cat /sys/class/drm/card${i}/device/pp_mclk_od
			cat /sys/class/drm/card${i}/device/pp_sclk_od
			echo 10 > /sys/class/drm/card${i}/device/pp_mclk_od
			echo 5 > /sys/class/drm/card${i}/device/pp_sclk_od
		fi
	done
	sudo -s -u st_lim \
		LD_LIBRARY_PATH=/opt/amdgpu-pro/lib/x86_64-linux-gnu $ETHMINER --farm-recheck 2000 \
		--verbosity $VERBOSITY \
		-S asia1.ethermine.org:4444 \
		-FS asia1.ethermine.org:14444 \
		--stratum-email st_lim\@stlim.net \
		--userpass a04954b34a5d54715b03d732caa9bc05ef4d6df5.stlimeth \
		-G --opencl-platform 1 --opencl-devices ${LIST_DEVICES}
}

start
