#!/bin/bash
set -x
set -e
set -u 

sudo apt-get install git curl vim-gtk mercurial
git config --global user.name "Dan Nuffer"
git config --global push.default matching


if ! [ -e ~/.ssh/id_rsa.pub ]; then
	ssh-keygen
	echo "Add this key to github"
	cat ~/.ssh/id_rsa.pub
	echo "Press enter when finished"
	read ans
fi

if ! [ -d ~/myvim ]; then
	pushd ~
	git clone ssh://git@github.com/dnuffer/myvim
	pushd ~/myvim
	./install.sh
	popd
	popd
fi

if ! [ -d ~/dpcode ]; then
	pushd ~
	git clone ssh://git@github.com/dnuffer/dpcode
	popd
fi

if ! [ -e /etc/sudoers.d/$USER ]; then
	OLD_MODE=`umask`
	umask 0227
	echo "Defaults always_set_home" | sudo tee -a /etc/sudoers.d/$USER
	echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/$USER
	umask $OLD_MODE
fi

# setup gnome-terminal unlimited scrollback and white on black color theme
gconftool --set /apps/gnome-terminal/profiles/Default/alternate_screen_scroll true --type bool
gconftool --set /apps/gnome-terminal/profiles/Default/scrollback_lines 512000 --type int
gconftool --set /apps/gnome-terminal/profiles/Default/use_theme_colors false --type bool
gconftool --set /apps/gnome-terminal/profiles/Default/palette '#2E2E34343636:#CCCC00000000:#4E4E9A9A0606:#C4C4A0A00000:#34346565A4A4:#757550507B7B:#060698209A9A:#D3D3D7D7CFCF:#555557575353:#EFEF29292929:#8A8AE2E23434:#FCFCE9E94F4F:#72729F9FCFCF:#ADAD7F7FA8A8:#3434E2E2E2E2:#EEEEEEEEECEC' --type string
gconftool --set /apps/gnome-terminal/profiles/Default/background_color '#000000000000' --type string
gconftool --set /apps/gnome-terminal/profiles/Default/bold_color '#000000000000' --type string
gconftool --set /apps/gnome-terminal/profiles/Default/foreground_color '#FFFFFFFFFFFF' --type string

# Set keyboard shortcuts (remove workspace switching keys which conflict with ides)
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "['']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['']"

if ! grep -q ccache ~/.bashrc; then
	echo "export PATH=/usr/lib/ccache:\$PATH" >> ~/.bashrc
fi

if ! grep -q "Eternal bash history" ~/.bashrc; then
cat >> ~/.bashrc << EOS
# Eternal bash history.
# http://superuser.com/questions/137438/how-to-unlimited-bash-shell-history
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="history -a; \$PROMPT_COMMAND"
EOS
fi

if ! grep StrictHostKeyChecking ~/.ssh/config; then
	echo 'Host *' >> ~/.ssh/config
	echo "  StrictHostKeyChecking no" >> ~/.ssh/config
fi

# broken
#if ! [ -e ~/.gvm ]; then
#	bash < <(curl -s https://raw.github.com/moovweb/gvm/master/binscripts/gvm-installer)
#	source $HOME/.gvm/scripts/gvm
#	gvm install go1.2.1
#	gvm use go1.2.1
#fi

if ! [ -e ~/.rvm ]; then
	gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
	curl -L https://get.rvm.io | bash -s stable --ruby
	set +e
	set +u
	source $HOME/.rvm/scripts/rvm
	set -e
	set -u
fi

if ! [ -e ~/.Renviron ]; then
	echo 'R_LIBS_USER="~/.Rlibs"' > ~/.Renviron
fi

if ! [ -e ~/.Rlibs ]; then
	mkdir ~/.Rlibs
fi

install_R_package() {
	package=$1
	if ! [ -e "$HOME/.Rlibs/$package" ]; then
		R -e "install.packages(\"$package\", dependencies = TRUE, repos=\"http://cran.cnr.Berkeley.edu\", lib=\"~/.Rlibs\")"
	fi
}

# TODO: figure out how to not install this globally and only for the project that uses it.
install_R_package knitr
install_R_package Hmisc
install_R_package maps
install_R_package devtools
install_R_package roxygen2
install_R_package testthat
install_R_package iterators
install_R_package caret
install_R_package doParallel
install_R_package e1071

if ! [ -e ~/bin ]; then
	mkdir ~/bin
fi

if ! grep -q \$HOME/bin ~/.bashrc; then
	echo "export PATH=\$HOME/bin:\$PATH" >> ~/.bashrc
fi

