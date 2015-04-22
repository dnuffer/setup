#!/bin/bash
set -x
set -e
set -u

if [ $UID != "0" ]; then
	echo "This script must be run as root" >&2
	exit 1
fi

apt-get -y install git curl wget

#sed -i -e 's/us.archive.ubuntu.com/mirrors.xmission.com/g' /etc/apt/sources.list
#sed -i -e 's/security.ubuntu.com/mirrors.xmission.com/g' /etc/apt/sources.list

if [ ! -e /etc/apt/sources.list.d/docker.list ]; then
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
	echo "deb http://get.docker.io/ubuntu docker main" > /etc/apt/sources.list.d/docker.list
	apt-get update
fi

if ! [ -e /etc/apt/sources.list.d/webupd8team-java-trusty.list ]; then
	add-apt-repository -y ppa:webupd8team/java
	apt-get -y update
fi

# The nvidia driver sucks for desktop use :-(
#if ! [ -e /etc/apt/sources.list.d/cuda.list ]; then
#	wget -O /tmp/cuda.deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/cuda-repo-ubuntu1404_6.5-14_amd64.deb
#	dpkg -i /tmp/cuda.deb
#	apt-get -y update
#fi


apt-get update

if ! [ -x /usr/lib/git-core/git-subtree ]; then
	cp /usr/share/doc/git/contrib/subtree/git-subtree.sh /usr/lib/git-core/git-subtree
	chmod +x /usr/lib/git-core/git-subtree
fi

apt-get -y dist-upgrade

apt-get install --fix-broken \
	alarm-clock-applet \
	anki \
	antiword \
	apt-file \
	apt-transport-https \
	autofs \
	bison \
	build-essential \
	bzr \
	capnproto \
	catdoc \
	ccache \
	clang \
	clisp \
	clojure1.4 \
	cmake \
	coffeescript \
	compizconfig-settings-manager \
	compiz-plugins-extra \
	default-jdk \
	djvulibre-bin \
	dos2unix \
	doxygen \
	dvipng \
	erlang \
	freemind \
	g++ \
	g++-4.6 \
	g++-4.6-multilib \
	gawk \
	gcc \
	gcc-4.6 \
	gcc-4.6-multilib \
	gfortran \
	gimp \
	git \
	git-gui \
	gitk \
	git-svn \
	gnuplot \
	gnuplot-x11 \
	gnustep-devel \
	gobjc \
	gobjc++ \
	gradle \
	groovy \
	htop \
	httpie \
	ifstat \
	imagemagick \
	inkscape \
	iotop \
	ipython \
	ipython3 \
	ipython3-notebook \
	ipython-notebook \
	jags \
	kcachegrind \
	libarmadillo-dev \
	libatlas-base-dev \
	libavcodec-dev \
	libavformat-dev \
	libav-tools \
	libboost1.55-all-dev \
	libboost-doc \
	libbz2-dev \
	libcapnp-dev \
	libclang-dev \
	libcommons-cli-java \
	libcurl4-openssl-dev \
	libdata-random-perl \
	libdc1394-22-dev \
	libffi-dev \
	libfftw3-dev \
	libfreeimage-dev \
	libgcc1-dbg \
	libgdbm-dev \
	libgd-perl \
	libgflags-dev \
	libglu1-mesa-dev \
	libgomp1-dbg \
	libgoogle-glog-dev \
	libgraphicsmagick1-dev \
	libgsl0-dev \
	libgtk2.0-dev \
	libhdf5-serial-dev \
	libimage-exiftool-perl \
	libjasper-dev \
	libjpeg62 \
	libjpeg-dev \
	liblapack-dev \
	libleveldb-dev \
	liblmdb-dev \
	libnet-dropbox-api-perl \
	libopenblas-dev \
	libopencv-dev \
	libopenjpeg-dev \
	libpng12-dev \
	libpng-dev \
	libprotobuf-dev \
	libqt4-core \
	libqt4-dev \
	libqt4-gui \
	libreadline-dev \
	libsdl2-dev \
	libsnappy-dev \
	libsox-dev \
	libsox-fmt-all \
	libsqlite3-dev \
	libssl-dev \
	libstdc++6-4.4-dbg \
	libswscale-dev \
	libthrust-dev \
	libtiff4-dev \
	libtool \
	libwebp-dev \
	libwpd-tools \
	libxml2-dev \
	libxslt1-dev \
	libxslt-dev \
	libyaml-dev \
	libzmq3-dev \
	lua5.2 \
	lua5.2-doc \
	lxc-docker \
	lyx \
	maven \
	meld \
	mercurial \
	molly-guard \
	monodevelop \
	mono-gmcs \
	mono-mcs \
	ncurses-dev \
	nethogs \
	network-manager-vpnc \
	nmap \
	nodejs \
	nodejs-legacy \
	npm \
	nunit-console \
	octave \
	octave-ga \
	octave-nnet \
	octave-optim \
	openjdk-6-doc \
	openjdk-6-jdk \
	openjdk-6-source \
	openjdk-7-doc \
	openjdk-7-jdk \
	openjdk-7-source \
	openjpeg-tools \
	oracle-java8-installer \
	p7zip-full \
	p7zip-rar \
	parallel \
	php5 \
	protobuf-compiler \
	pstotext \
	python \
	python3 \
	python3-dev \
	python3-mako \
	python3-matplotlib \
	python3-nose \
	python3-numpy \
	python3-pandas \
	python3-pil \
	python3-pip \
	python3-pytools \
	python3-scipy \
	python3-skimage \
	python3-zmq \
	python-cairo-dev \
	python-chardet \
	python-chm \
	python-dev \
	python-easygui \
	python-gi-dev \
	python-gtk2-dev \
	python-jinja2 \
	python-magic \
	python-mako \
	python-matplotlib \
	python-matplotlib-doc \
	python-mutagen \
	python-nose \
	python-numpy \
	python-opencv \
	python-pandas \
	python-pil \
	python-pip \
	python-pytools \
	python-qt4-dev \
	python-scipy \
	python-skimage \
	python-skimage-doc \
	python-sklearn \
	python-sklearn-doc \
	python-sympy \
	python-tk \
	python-virtualenv \
	python-yaml \
	r-base \
	r-base-dev \
	r-cran-boot \
	r-cran-class \
	r-cran-cluster \
	r-cran-codetools \
	r-cran-foreign \
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
	scala \
	screen \
	shutter \
	smartmontools \
	sox \
	ssh \
	sshfs \
	subversion \
	texlive-latex-base \
	tk-dev \
	tree \
	ttf-bitstream-vera \
	ttf-dejavu \
	ttf-staypuft \
	ubuntu-restricted-extras \
	unattended-upgrades \
	unrar \
	unrtf \
	untex \
	unzip \
	vagrant \
	valgrind \
	vim \
	vim-doc \
	vim-gnome \
	vim-gtk \
	virtualbox \
	vlc \
	vpnc \
	webp \
	wv \
	wxmaxima \
	xchat


#if lspci | grep -q VMware; then
#	apt-get -y install \
#		open-vm-tools \
#		open-vm-toolbox \
#		open-vm-dkms
#fi

if ! [ -e /etc/cron.weekly/fstrim ]; then
cat > /etc/cron.weekly/fstrim << EOS
#!/bin/sh
for mount in /; do
	fstrim \$mount
done
EOS
chmod 755 /etc/cron.weekly/fstrim
fi

sed -i -e 's/^#\/net	-hosts$/\/net	-hosts/' /etc/auto.master
restart autofs

if ! [ -e /usr/local/include/glog ]; then
	glog_url=https://google-glog.googlecode.com/files/glog-0.3.3.tar.gz
	pushd /tmp
	wget "$glog_url"
	tar zxvf glog-0.3.3.tar.gz
	pushd glog-0.3.3
	./configure
	make && make install
	popd
	rm -rf glog-0.3.3
	popd
fi

if ! dpkg -l google-chrome-stable | grep '^ii.*google-chrome-stable'; then
	wget -O /tmp/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	dpkg -i /tmp/google-chrome-stable_current_amd64.deb || true
	apt-get -fy install
fi

# broken by the website
#if ! dpkg -l sbt; then
#	latest_sbt_url=$(wget -q -O- http://www.scala-sbt.org/release/docs/Getting-Started/Setup.html | grep -o -P 'https?://repo\.scala-sbt\.org/[^"]*sbt\.deb' | tail -1)
#	wget -O /tmp/sbt.deb "$latest_sbt_url"
#	dpkg -i /tmp/sbt.deb || true
#	apt-get -fy install
#fi

# broken
#if ! [ -e /usr/local/scala/eclipse ]; then
#	latest_scala_eclipse_url=$(wget -q -O- http://scala-ide.org/download/sdk.html | grep -o -P 'https?://.*typesafe\.com/.*/scala-SDK-.*-linux.gtk.x86_64.tar.gz' | tail -1)
#	wget -O /tmp/scala-sdk.tar.gz "$latest_scala_eclipse_url"
#	mkdir -p /usr/local/scala
#	tar xzvf /tmp/scala-sdk.tar.gz -C /usr/local/scala
#fi

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

# Install python rarfile module for recoll indexing of rar files
if ! [ -e /usr/local/lib/python2.7/dist-packages/rarfile.py ]; then
	pip install rarfile
fi

install_vmware=false
if [ "$install_vmware" = "true" ]; then
	if ! [ -e /usr/bin/vmware ]; then
		if [ -e /net/hurley/storage/data/pub/software/VMware/VMware-Workstation-Full-10.0.1-1379776.x86_64.bundle ]; then
			yes yes | sh -c 'PAGER=/bin/cat sh /net/hurley/storage/data/pub/software/VMware/VMware-Workstation-Full-10.0.1-1379776.x86_64.bundle --console --required'
			/usr/lib/vmware/bin/vmware-vmx --new-sn `cat /net/hurley/storage/data/pub/software/VMware/serials/Workstation10.txt`
		else
			echo "VMware Workstation not installed because the install isn't at the expected path" >&2
		fi
	fi

	if ! [ -e /usr/lib/vmware-cip/5.5.0 ]; then
		if [ -e /net/hurley/storage/data/pub/software/VMware/VMware-ClientIntegrationPlugin-5.5.0.x86_64.bundle ]; then
			yes yes | sh -c 'PAGER=/bin/cat sh /net/hurley/storage/data/pub/software/VMware/VMware-ClientIntegrationPlugin-5.5.0.x86_64.bundle --console --required'
		fi
	fi
fi

# broken
#if ! [ -e /usr/local/crashplan/bin ]; then
#	if ! [ -e /tmp/CrashPlan-install ]; then
#		wget -O- http://download.code42.com/installs/linux/install/CrashPlan/CrashPlan_3.7.0_Linux.tgz | tar -C /tmp -xzvf -
#	fi
#	pushd /tmp/CrashPlan-install
#	echo "fs.inotify.max_user_watches=10485760" >> /etc/sysctl.conf
#	sysctl -p
#	echo '#!/bin/sh' > more
#	chmod +x more
#	bash -c 'PATH=.:/usr/bin:/bin:/usr/sbin:/sbin ./install.sh' << EOS
#
#
#
#yes
#EOS
#	popd
#	rm -rf /tmp/CrashPlan-install
#fi


echo "vm.swappiness=1" > /etc/sysctl.d/99-dan.conf
sysctl --system

# May want to make this conditional on something, but I'm not sure what. Maybe just leave it out?
#update-java-alternatives --set java-7-oracle

if ! [ -e /usr/lib/jvm/java-7-openjdk-amd64/src.zip ]; then
	ln -s ../java-7-openjdk-i386/src.zip /usr/lib/jvm/java-7-openjdk-amd64/src.zip
fi

if ! [ -e /usr/lib/jvm/java-6-openjdk-amd64/src.zip ]; then
	ln -s ../java-6-openjdk-i386/src.zip /usr/lib/jvm/java-6-openjdk-amd64/src.zip
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

if ! [ -e /etc/X11/xorg.conf.d ]; then
	mkdir -p /etc/X11/xorg.conf.d
fi
if ! [ -e /etc/X11/xorg.conf.d/50-synaptics.conf ]; then
cat >> /etc/X11/xorg.conf.d/50-synaptics.conf << EOS
# Example xorg.conf.d snippet that assigns the touchpad driver
# to all touchpads. See xorg.conf.d(5) for more information on
# InputClass.
# DO NOT EDIT THIS FILE, your distribution will likely overwrite
# it when updating. Copy (and rename) this file into
# /etc/X11/xorg.conf.d first.
# Additional options may be added in the form of
#   Option "OptionName" "value"
#
Section "InputClass"
        Identifier "touchpad catchall"
        Driver "synaptics"
        MatchIsTouchpad "on"
# This option is recommend on all Linux systems using evdev, but cannot be
# enabled by default. See the following link for details:
# http://who-t.blogspot.com/2010/11/how-to-ignore-configuration-errors.html
      MatchDevicePath "/dev/input/event*"
EndSection

Section "InputClass"
        Identifier "touchpad ignore duplicates"
        MatchIsTouchpad "on"
        MatchOS "Linux"
        MatchDevicePath "/dev/input/mouse*"
        Option "Ignore" "on"
EndSection

# This option enables the bottom right corner to be a right button on
# non-synaptics clickpads.
# This option is only interpreted by clickpads.
Section "InputClass"
        Identifier "Default clickpad buttons"
        MatchDriver "synaptics"
        Option "SoftButtonAreas" "100% 0 100% 0 0 0 0 0"
#       To disable the bottom edge area so the buttons only work as buttons,
#       not for movement, set the AreaBottomEdge
#       Option "AreaBottomEdge" "82%"
EndSection

# This option disables software buttons on Apple touchpads.
# This option is only interpreted by clickpads.
Section "InputClass"
        Identifier "Disable clickpad buttons on Apple touchpads"
        MatchProduct "Apple|bcm5974"
        MatchDriver "synaptics"
        Option "SoftButtonAreas" "0 0 0 0 0 0 0 0"
EndSection
EOS
fi

#if ! grep -q '^GRUB_TERMINAL=console$' /etc/default/grub; then
#cat >> /etc/default/grub << EOS
#GRUB_TERMINAL=console
#EOS
#update-grub
#fi
