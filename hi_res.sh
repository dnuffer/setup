#!/bin/bash
set -x
set -e
set -u

if [ $UID != "0" ]; then
	echo "This script must be run as root" >&2
	exit 1
fi

patch -p0 -N -r- /usr/share/themes/Ambiance/metacity-1/metacity-theme-1.xml < metacity-theme-1.xml.patch
gsettings set org.gnome.desktop.interface scaling-factor 2
gsettings set org.gnome.desktop.interface text-scaling-factor 0.8
echo "Open System Settings->Displays and change UI Scale to 1.5"
