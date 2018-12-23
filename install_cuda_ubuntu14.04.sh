#!/bin/bash
set -x
set -e
set -u

if [ $UID != "0" ]; then
	echo "This script must be run as root" >&2
	exit 1
fi

apt-get -y remove nvidia-cuda-* wine

# The nvidia driver sucks for desktop use :-(
if ! [ -e /etc/apt/sources.list.d/cuda.list ]; then
	wget -O /tmp/cuda.deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/cuda-repo-ubuntu1404_6.5-14_amd64.deb
	dpkg -i /tmp/cuda.deb
	apt-get -y update
fi

apt-get -y install --install-recommends --fix-broken --ignore-hold --auto-remove \
	cuda \
	nvidia-prime \
	nvidia-modprobe
