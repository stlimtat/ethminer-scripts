# ethminer-scripts
Ethminer scripts because my machine is a wee bit too unstable

I installed all the following on a latest copy of Ubuntu 17.04.  Friends asked me why I do not use the LTS version, but well.

My mining rig consists of the following:
a. AsRock H110 BTC+ Pro motherboard - supports 13 PCI-E cards, and super stable
b. Intel G5400 processor
c. 4GB Crucial RAM
d. Some really old 120GB SSD
e. Gigabyte G1 Gaming GTX 1070 x 03
f. Asus ROG Strix Radeon RX570 x 01

The rig currently churns out an average of 104 MH/s, with power consumption of about 540W.  

Overall rig is 4k, and I expect to break even after 2 years on a basis of zero inflation.

https://ethermine.org/miners/a04954b34a5d54715b03d732caa9bc05ef4d6df5

Instructions to follow:

- http://1stminingrig.com/best-mining-rig-hardware-mine-2017/
- https://github.com/ethereum-mining/ethminer
- https://forum.ethereum.org/discussion/7780/gtx1070-linux-installation-and-mining-clue-goodbye-amd-welcome-nvidia-for-miners

1. After installing ubuntu (I have a tendency to use the server version) on the SSD, reboot
1. Run the following commands to upgrade the machine apt-get install -y opencl-headers build-essential protobuf-compiler libprotoc-dev libboost-all-dev libleveldb-dev hdf5-tools libhdf5-serial-dev libopencv-core-dev libopencv-highgui-dev libsnappy-dev libsnappy1 libatlas-base-dev cmake libstdc++6-4.8-dbg libgoogle-glog0 libgoogle-glog-dev libgflags-dev liblmdb-dev git python-pip gfortran python-twisted

1. Copy all the files here into the relevant directory
1. Add the following to crontab -e on root
> */5 * * * * /bin/bash /usr/local/bin/monitorFarm.sh 0
> */5 * * * * /bin/bash /usr/local/bin/monitorFarm.sh 1
1. Run the following command on 
