#!/bin/bash
set -x
set -e
set -u

if [ $UID != "0" ]; then
	echo "This script must be run as root" >&2
	exit 1
fi

apt-get -y update
apt-get -y install git curl wget apt-transport-https ca-certificates software-properties-common

RELEASE_CODENAME=$(lsb_release -cs)

# As of 11/15/18, this ppa doesn't support 18.10
#if [ ! -e /etc/apt/sources.list.d/recoll-backports-ubuntu-recoll-1_15-on-$RELEASE_CODENAME.list ]; then
#	add-apt-repository -y ppa:recoll-backports/recoll-1.15-on
#	apt-get -y update
#fi

if [ ! -e /etc/apt/sources.list.d/insync.list ]; then
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ACCAF35C
	echo 'deb http://apt.insynchq.com/ubuntu '$RELEASE_CODENAME' non-free contrib' > /etc/apt/sources.list.d/insync.list
	apt-get -y update
fi

if [ ! -e /etc/apt/sources.list.d/docker.list ]; then
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
	# As of 11/15/18, this repo doesn't support 18.10
	#echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
	echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" > /etc/apt/sources.list.d/docker.list
	apt-get -y update
fi

if [ ! -e /etc/apt/sources.list.d/nvidia-docker.list ]; then
	curl -fsSL https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -
	# As of 11/15/18, this repo doesn't support 18.10, use the 18.04 repo
	#distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
	#curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list > /etc/apt/sources.list.d/nvidia-docker.list
	curl -s -L https://nvidia.github.io/nvidia-docker/ubuntu18.04/nvidia-docker.list > /etc/apt/sources.list.d/nvidia-docker.list
	sudo apt-get update
fi

apt-get -y update

apt-get -y dist-upgrade

GO_PKGS="golang"
MY_TOOLS="alarm-clock-applet anki lyx meld gimp git-gui gitk htop httpie ifstat inkscape iotop molly-guard nethogs nmap linux-tools-generic ncdu csvkit python3-csvkit whois lm-sensors texlive-full insync xclip parallel p7zip-rar p7zip-full vim vim-doc vim-gnome vim-gtk virtualbox apt-file dos2unix dvipng tree vagrant valgrind vlc "
MISC="tmux byobu screen ssh "
DEV_PACKAGES="bison libboost-all-dev build-essential bzr ccache clang cmake g++ gcc git-svn gradle kcachegrind libcurl4-openssl-dev libopencv-dev libssl-dev libtool mercurial openjdk-8-dbg openjdk-8-doc openjdk-8-jdk openjdk-8-source openjdk-11-dbg openjdk-11-doc openjdk-11-jdk openjdk-11-source zlib1g-dev default-jdk doxygen gawk "
PYTHON2_BASIC="python python-all python-all-dev python-dev python-pip python-setuptools python-wheel python-virtualenv ipython "
PYTHON3_BASIC="python3 python3-all python3-all-dev python3-dev python3-pip python3-setuptools python3-wheel python3-virtualenv ipython3 virtualenv "
RECOLL_PACKAGES="recoll antiword catdoc djvulibre-bin libimage-exiftool-perl libwpd-tools pstotext python3-mutagen python-chm python-mutagen p7zip-rar p7zip-full unrar unrtf untex wv "
R_PACKAGES="r-base r-base-dev r-cran-boot r-cran-class r-cran-cluster r-cran-codetools r-cran-foreign r-cran-ggplot2 r-cran-kernsmooth r-cran-lattice r-cran-mass r-cran-matrix r-cran-mcmcpack r-cran-mgcv r-cran-nlme r-cran-nnet r-cran-rjags r-cran-rodbc r-cran-rpart r-cran-spatial r-cran-survival "
DEV_TOOLS="octave subversion "
SYSTEM_PACKAGES="apt-transport-https autofs smartmontools ttf-bitstream-vera ttf-dejavu ubuntu-restricted-extras unattended-upgrades "
DOCKER="docker-ce nvidia-docker2"

apt-get install --fix-broken \
	$GO_PKGS \
	$MY_TOOLS \
	$MISC \
	$DEV_PACKAGES \
	$PYTHON2_BASIC \
	$PYTHON3_BASIC \
	$RECOLL_PACKAGES \
	$R_PACKAGES \
	$DEV_TOOLS \
	$SYSTEM_PACKAGES \
	$DOCKER
	


if ! grep -q "^/net\s*-hosts$" /etc/auto.master; then
	sed -i -e 's/^#\/net	-hosts$/\/net	-hosts/' /etc/auto.master
	service autofs restart
fi

if ! dpkg -l google-chrome-stable | grep '^ii.*google-chrome-stable'; then
	wget -O /tmp/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	dpkg -i /tmp/google-chrome-stable_current_amd64.deb || true
	apt-get -fy install
fi

if ! [ -e /usr/bin/rstudio ]; then
	latest_r_studio_url=$(wget -q -O- http://www.rstudio.com/ide/download/desktop | grep -o -P 'https?://.*\.rstudio\.org/rstudio-.*-amd64\.deb' | tail -1)
	wget -O /tmp/rstudio.deb "$latest_r_studio_url"
	dpkg -i /tmp/rstudio.deb || true
	apt-get -fy install
fi

if ! dpkg -l google-talkplugin; then
	wget -O /tmp/google-talkplugin_current_amd64.deb https://dl.google.com/linux/direct/google-talkplugin_current_amd64.deb
	dpkg -i /tmp/google-talkplugin_current_amd64.deb || true
	apt-get -fy install
fi

# Install python epub module for recoll indexing of epub files
if ! [ -e /usr/local/lib/python2.7/dist-packages/epub ]; then
	pip install epub
fi
if ! [ -e /usr/local/lib/python3.5/dist-packages/epub ]; then
	pip3 install epub
fi

# Install python rarfile module for recoll indexing of rar files
if ! [ -e /usr/local/lib/python2.7/dist-packages/rarfile.py ]; then
	pip install rarfile
fi
if ! [ -e /usr/local/lib/python3.5/dist-packages/rarfile.py ]; then
	pip3 install rarfile
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

if ! grep -q '^GRUB_TERMINAL=console$' /etc/default/grub; then
cat >> /etc/default/grub << EOS
GRUB_TERMINAL=console
EOS
update-grub
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
