#!/bin/bash
LOCK=275
MEM=1775
CMD='/usr/bin/nvidia-settings'
LOCK=/tmp/nvidia-overclock.tmp

if [ -f $LOCK ]; then
	exit 0
fi

start() {
	# exec 1> >(/usr/bin/logger -p mail.info -s -t $(basename $0)) 2>&1
	X :0 -core &
	sleep 10
	export DISPLAY=:0.0
	nvidia-smi -ac 1911,4004

	${CMD} -q all > /tmp/nvidia-settings.all 2>&1

	echo "performance" >/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
	echo "performance" >/sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
	echo 2800000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	echo 2800000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq

	for i in {0..3}; do
		nvidia-smi -i ${i} -pm 0
		nvidia-smi -i ${i} -pl 170
		#    nvidia-smi -i ${i} -ac 4004,1911
		${CMD} -a [gpu:${i}]/GPUPowerMizerMode=1
		${CMD} -a [gpu:${i}]/GPUFanControlState=1
		${CMD} -a [fan:${i}]/GPUTargetFanSpeed=80
		for x in {3..3}; do
			${CMD} -a [gpu:${i}]/GPUGraphicsClockOffset[${x}]=${CLOCK}
			${CMD} -a [gpu:${i}]/GPUMemoryTransferRateOffset[${x}]=${MEM}
		done
	done
	sleep 10
	killall -9 X
	killall -9 Xorg
	killall -9 X.wrap
	touch $LOCK
	sleep 5
	return 0
}

case $1 in
	start|stop) "$1";;
esac
