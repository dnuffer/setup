#!/bin/bash
set -x
set -e
set -u

if [ $UID != "0" ]; then
	echo "This script must be run as root" >&2
	exit 1
fi

apt-get -y install git curl wget

RELEASE_CODENAME=$(lsb_release -cs)

if [ ! -e /etc/apt/sources.list.d/recoll-backports-ubuntu-recoll-1_15-on-$RELEASE_CODENAME.list ]; then
	add-apt-repository -y ppa:recoll-backports/recoll-1.15-on
	apt-get -y update
fi

if [ ! -e /etc/apt/sources.list.d/insync.list ]; then
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ACCAF35C
	echo 'deb http://apt.insynchq.com/ubuntu '$RELASE_CODENAME' non-free contrib' > /etc/apt/sources.list.d/insync.list
	apt-get -y update
fi

apt-get update

apt-get -y dist-upgrade

GO_PKGS="golang"
DOCKER_PKGS="docker.io"
MY_TOOLS="alarm-clock-applet anki lyx meld gimp git-gui gitk htop httpie ifstat inkscape iotop molly-guard nethogs nmap linux-tools-generic ncdu python-csvkit python3-csvkit whois lm-sensors texlive-full insync"
MISC="tmux"
DEV_PACKAGES="bison libboost-all-dev build-essential bzr ccache clang cmake g++ gcc git-svn gradle kcachegrind libcurl4-openssl-dev libopencv-dev libssl-dev libtool mercurial openjdk-8-dbg openjdk-8-doc openjdk-8-jdk openjdk-8-source zlib1g-dev"

apt-get install --fix-broken \
	$GO_PKGS \
	$DOCKER_PKGS \
	$MY_TOOLS \
	$MISC \
	$DEV_PACKAGES \
	antiword \
	apt-file \
	apt-transport-https \
	autofs \
	catdoc \
	default-jdk \
	djvulibre-bin \
	dos2unix \
	doxygen \
	dvipng \
	gawk \
	ipython \
	ipython3 \
	ipython3-notebook \
	ipython-notebook \
	libav-tools \
	libimage-exiftool-perl \
	libwpd-tools \
	octave \
	p7zip-full \
	p7zip-rar \
	parallel \
	pstotext \
	python \
	python3 \
	python3-all \
	python3-all-dev \
	python3-dev \
	python3-magic \
	python3-matplotlib \
	python3-mutagen \
	python3-nose \
	python3-numpy \
	python3-numpydoc \
	python3-pandas \
	python3-pip \
	python3-scipy \
	python3-seaborn \
	python3-setuptools \
	python3-skimage \
	python3-sklearn \
	python3-sklearn-pandas \
	python3-virtualenv \
	python3-wheel \
	python-all \
	python-all-dev \
	python-chm \
	python-dev \
	python-magic \
	python-matplotlib \
	python-mutagen \
	python-nose \
	python-numpy \
	python-numpydoc \
	python-opencv \
	python-pandas \
	python-pandas-doc \
	python-pip \
	python-scipy \
	python-seaborn \
	python-setuptools \
	python-skimage \
	python-skimage-doc \
	python-sklearn \
	python-sklearn-doc \
	python-sklearn-pandas \
	python-virtualenv \
	python-wheel \
	r-base \
	r-base-dev \
	r-cran-boot \
	r-cran-class \
	r-cran-cluster \
	r-cran-codetools \
	r-cran-foreign \
	r-cran-ggplot2 \
	r-cran-kernsmooth \
	r-cran-lattice \
	r-cran-mass \
	r-cran-matrix \
	r-cran-mcmcpack \
	r-cran-mgcv \
	r-cran-nlme \
	r-cran-nnet \
	r-cran-rjags \
	r-cran-rodbc \
	r-cran-rpart \
	r-cran-spatial \
	r-cran-survival \
	recoll \
	screen \
	shutter \
	smartmontools \
	ssh \
	subversion \
	tree \
	ttf-bitstream-vera \
	ttf-dejavu \
	ubuntu-restricted-extras \
	unattended-upgrades \
	unity-scope-recoll \
	unrar \
	unrtf \
	untex \
	vagrant \
	valgrind \
	vim \
	vim-doc \
	vim-gnome \
	vim-gtk \
	virtualbox \
	vlc \
	wv \
	wxmaxima


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

if ! dpkg -l rescuetime; then
	wget -O /tmp/rescuetime_current_amd64.deb https://www.rescuetime.com/installers/rescuetime_current_amd64.deb
	dpkg -i /tmp/rescuetime_current_amd64.deb || true
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

if ! [ -e /usr/local/crashplan/bin ]; then
	if ! [ -e /tmp/crashplan-install ]; then
		wget -O- https://download1.code42.com/installs/linux/install/CrashPlan/CrashPlan_4.8.0_Linux.tgz | tar -C /tmp -xzvf -
	fi
	pushd /tmp/crashplan-install
	echo "fs.inotify.max_user_watches=10485760" >> /etc/sysctl.d/98-crashplan.conf
	sysctl --system
	echo '#!/bin/sh' > more
	chmod +x more
	bash -c 'PATH=.:/usr/bin:/bin:/usr/sbin:/sbin ./install.sh' << EOS



yes
EOS
	popd
	rm -rf /tmp/crashplan-install
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
