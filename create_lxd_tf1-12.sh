#!/bin/bash
set -x
set -e
set -u

container_name=tf1-12
lxc launch ubuntu:16.04 $container_name -c nvidia.runtime=true
lxc config device add $container_name gpu gpu
lxc exec $container_name -- nvidia-smi
lxc file push "$(dirname "$(readlink -f "$0")")/install_cuda9_ubuntu16.04.sh" $container_name/root/
while ! lxc exec $container_name -- test -e /var/lib/cloud/instance/boot-finished; do
	echo "waiting for networking"
	sleep 1
done
lxc exec $container_name -- /root/install_cuda9_ubuntu16.04.sh
echo 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/local/cuda/bin"' | lxc exec $container_name -- tee /etc/environment
lxc file push "$(dirname "$(readlink -f "$0")")/cuda_path.sh" $container_name/etc/profile.d/cuda_path.sh
lxc exec $container_name -- apt-get install -y python python-dev python3 python3-dev python-pip python3-pip
lxc exec $container_name -- pip install tensorflow-gpu
lxc exec $container_name -- pip3 install tensorflow-gpu

# install misc utilities
lxc exec $container_name -- apt install -y git htop ncdu python-csvkit python3-csvkit xclip parallel vim vim-doc dos2unix tree tmux byobu screen

# setup a user
lxc exec $container_name -- deluser --remove-home ubuntu
lxc exec $container_name -- adduser --uid $(id -u) --gecos "" --disabled-password $USER
pwhash=$(sudo grep "^$USER:" /etc/shadow | cut -d : -f 2)
echo "$USER:$pwhash" | lxc exec $container_name -- chpasswd -e
for extra_group in adm cdrom sudo dip plugdev; do
	lxc exec $container_name -- adduser $USER $extra_group
done
lxc file push ~/.ssh $container_name/home/$USER/ -p -r
lxc file push "$(dirname "$(readlink -f "$0")")" $container_name/home/$USER/ -p -r
lxc exec $container_name -- /bin/bash -c 'echo "Defaults always_set_home" | tee /etc/sudoers.d/'$USER
lxc exec $container_name -- /bin/bash -c 'echo "'$USER' ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/'$USER
lxc exec $container_name -- sudo -S -u $USER --set-home bash -c 'cd /home/'$USER'/setup; ./home.sh'
