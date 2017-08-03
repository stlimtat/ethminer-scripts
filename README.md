# ethminer-scripts
Ethminer scripts because my machine is a wee bit too unstable

I installed all the following on a latest copy of Ubuntu 17.04.  Friends asked me why I do not use the LTS version, but well.

My mining rig consists of the following:
1. AsRock H110 BTC+ Pro motherboard - supports 13 PCI-E cards, and super stable
1. Intel Pentium CPU G4400 processor @ 3.30 GHz
1. 4GB Crucial RAM
1. Some really old 120GB SSD
1. Gigabyte G1 Gaming GTX 1070 x 03
1. Asus ROG Strix Radeon RX570 x 01

The rig currently churns out an average of 104 MH/s, with power consumption of about 540W.  

Overall rig cost SGD 4k, and I expect to break even after 2 years on a basis of zero inflation.

> https://ethermine.org/miners/a04954b34a5d54715b03d732caa9bc05ef4d6df5

Instructions to follow:

- http://1stminingrig.com/best-mining-rig-hardware-mine-2017/
- https://github.com/ethereum-mining/ethminer
- https://forum.ethereum.org/discussion/7780/gtx1070-linux-installation-and-mining-clue-goodbye-amd-welcome-nvidia-for-miners

1. After installing ubuntu (I have a tendency to use the server version) on the SSD, reboot
1. Run the following commands to upgrade the machine:

        sudo apt-get update 
        sudo apt-get -f -y dist-upgrade 
        sudo apt-get install -y \
            opencl-headers \
            build-essential \
            protobuf-compiler \
            libprotoc-dev \
            libboost-all-dev \
            libleveldb-dev \
            hdf5-tools \
            libhdf5-serial-dev \
            libopencv-core-dev \
            libopencv-highgui-dev \
            libsnappy-dev \
            libsnappy1 \
            libatlas-base-dev \
            cmake \
            libstdc++6-4.8-dbg \
            libgoogle-glog0 \
            libgoogle-glog-dev \
            libgflags-dev \
            liblmdb-dev \
            git \
            python-pip \
            gfortran \
            python-twisted \
            gcc-4.9 \
            g++-4.9
        sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.6
        sudo apt-get install software-properties-common
        sudo add-apt-repository ppa:ethereum/ethereum
        sudo apt-get update
        sudo apt-get install ethereum
        curl -O cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb
        sudo dpkg -i cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb
        sudo apt-get update
        sudo apt-get install -y cuda nvidia-375 
        mkdir $HOME/src
        cd $HOME/src
        git clone https://github.com/ethereum-mining/ethminer.git
        cd ethminer
        mkdir build
        cmake .. -DETHASHCUDA=ON
        cmake --build .
        sudo make install
1. Copy all the files here into the relevant directory
1. Add the following to crontab -e on root - TODO: Move this to a file in /etc/cron.d and test properly

        */5 * * * * /bin/bash /usr/local/bin/monitorFarm.sh 0
        */5 * * * * /bin/bash /usr/local/bin/monitorFarm.sh 1
1. Part of the installation includes a .tmux.conf which must be used to replace your $HOME/.byobu/.tmux.conf
1. Another change you need to make is to the files which currently all point to /home/st_lim which is probably a different directory for all of you guys.

        find . -type f -exec sed -e 's/\/home\/st_lim/\/home\/<yourid>/g' {} \;
