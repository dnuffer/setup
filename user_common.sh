#!/bin/bash
set -x
set -e
set -u 

sudo apt-get install git curl vim-gtk
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

if ! [ -e /etc/sudoers.d/$USER ]; then
	OLD_MODE=`umask`
	umask 0227
	echo "Defaults always_set_home" | sudo tee -a /etc/sudoers.d/$USER
	echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/$USER
	umask $OLD_MODE
fi

if [ -e /usr/bin/gconftool ]; then
	# setup gnome-terminal unlimited scrollback and white on black color theme
	gconftool --set /apps/gnome-terminal/profiles/Default/alternate_screen_scroll true --type bool
	gconftool --set /apps/gnome-terminal/profiles/Default/scrollback_lines 512000 --type int
	gconftool --set /apps/gnome-terminal/profiles/Default/use_theme_colors false --type bool
	gconftool --set /apps/gnome-terminal/profiles/Default/palette '#2E2E34343636:#CCCC00000000:#4E4E9A9A0606:#C4C4A0A00000:#34346565A4A4:#757550507B7B:#060698209A9A:#D3D3D7D7CFCF:#555557575353:#EFEF29292929:#8A8AE2E23434:#FCFCE9E94F4F:#72729F9FCFCF:#ADAD7F7FA8A8:#3434E2E2E2E2:#EEEEEEEEECEC' --type string
	gconftool --set /apps/gnome-terminal/profiles/Default/background_color '#000000000000' --type string
	gconftool --set /apps/gnome-terminal/profiles/Default/bold_color '#000000000000' --type string
	gconftool --set /apps/gnome-terminal/profiles/Default/foreground_color '#FFFFFFFFFFFF' --type string
fi

if [ -e /usr/bin/gsettings ]; then
	# Set keyboard shortcuts (remove workspace switching keys which conflict with ides)
	gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "['']"
	gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['']"
	gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['']"
	gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['']"
fi

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

# Disable ctrl-s pause
if ! grep -q "stty -ixon" ~/.bashrc; then
cat >> ~/.bashrc << EOS
stty -ixon
EOS
fi

if ! grep StrictHostKeyChecking ~/.ssh/config; then
	echo 'Host *' >> ~/.ssh/config
	echo "  StrictHostKeyChecking no" >> ~/.ssh/config
fi

if ! [ -e ~/.Renviron ]; then
	echo 'R_LIBS_USER="~/.Rlibs"' > ~/.Renviron
fi

if ! [ -e ~/.Rlibs ]; then
	mkdir ~/.Rlibs
fi

if ! [ -e ~/bin ]; then
	mkdir ~/bin
fi

if ! grep -q \$HOME/bin ~/.bashrc; then
	echo "export PATH=\$HOME/bin:\$PATH" >> ~/.bashrc
fi

if ! grep -q termcapinfo ~/.screenrc; then
	echo "termcapinfo xterm* ti@:te@" >> ~/.screenrc
fi

if ! grep -q "Initializing new SSH agent" ~/.bash_profile; then
cat >> ~/.bash_profile << EOS
SSH_ENV="\$HOME/.ssh/environment"

function start_agent {
    echo "Initializing new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "\${SSH_ENV}"
    echo succeeded
    chmod 600 "\${SSH_ENV}"
    . "\${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "\${SSH_ENV}" ]; then
    . "\${SSH_ENV}" > /dev/null
    #ps \${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep \${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi
EOS
fi

sudo usermod -aG docker $USER

# shut up parallel's stupid citation message
mkdir -p ~/.parallel
touch ~/.parallel/will-cite
