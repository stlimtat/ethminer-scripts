# ethminer-scripts
Ethminer scripts because my machine is a wee bit too unstable

You will need to copy this to every of your directory as per the layout in this repository.

Add the following to crontab -e on root

*/5 * * * * /bin/bash /usr/local/bin/monitorFarm.sh 0
*/5 * * * * /bin/bash /usr/local/bin/monitorFarm.sh 1
