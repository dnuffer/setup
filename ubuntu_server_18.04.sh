#!/bin/bash
set -x
set -e
set -u

if [ $UID != "0" ]; then
	echo "This script must be run as root" >&2
	exit 1
fi

apt-get -y update
apt-get -y install git curl wget apt-transport-https ca-certificates

RELEASE_CODENAME=$(lsb_release -cs)

if [ ! -e /etc/apt/sources.list.d/docker.list ]; then
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
	echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
	apt-get -y update
fi

if [ ! -e /etc/apt/sources.list.d/nvidia-docker.list ]; then
	curl -fsSL https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -
	distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
	curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list > /etc/apt/sources.list.d/nvidia-docker.list
	apt-get -y update
fi

apt-get -y update

apt-get dist-upgrade

MY_TOOLS="htop ifstat iotop molly-guard nethogs nmap linux-tools-generic ncdu whois lm-sensors parallel p7zip-rar p7zip-full vim vim-doc dos2unix tree"
MISC="tmux byobu ssh"
SYSTEM_PACKAGES="autofs smartmontools"
DOCKER="docker-ce nvidia-docker2"

apt-get install --fix-broken \
	$MY_TOOLS \
	$MISC \
	$SYSTEM_PACKAGES \
	$DOCKER

if ! grep -q "^/net\s*-hosts$" /etc/auto.master; then
	sed -i -e 's/^#\/net	-hosts$/\/net	-hosts/' /etc/auto.master
	service autofs restart
fi

# The next three file modifications are to raise the ridicuously low file descriptor limit.
if ! grep 'root hard nofile' /etc/security/limits.conf; then
cat >> /etc/security/limits.conf << EOS
* soft nofile 100000
* hard nofile 100000
root soft nofile 100000
root hard nofile 100000
EOS
fi

if ! grep '^session required pam_limits.so$' /etc/pam.d/common-session; then
cat >> /etc/pam.d/common-session << EOS
session required pam_limits.so
EOS
fi

if ! grep '^session required pam_limits.so$' /etc/pam.d/common-session-noninteractive; then
cat >> /etc/pam.d/common-session-noninteractive << EOS
session required pam_limits.so
EOS
fi

if ! grep -q '"default-runtime": "nvidia",' /etc/docker/daemon.json; then
cat > /etc/docker/daemon.json << EOS
{
    "default-runtime": "nvidia",
    "runtimes": {
        "nvidia": {
            "path": "nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
EOS
service docker restart
fi
