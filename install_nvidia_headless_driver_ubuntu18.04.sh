#!/bin/bash
set -x
set -e
set -u

if [ $UID != "0" ]; then
	echo "This script must be run as root" >&2
	exit 1
fi

apt-get update && apt-get install --no-install-recommends gnupg2 curl ca-certificates
curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add -
echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list
apt-get update

apt-get install --no-install-recommends \
	nvidia-headless-410 \
	nvidia-utils-410 \
	nvidia-modprobe
