#!/bin/sh
if [ ! -e ~/.inputrc ]; then
cat >> ~/.inputrc << EOS
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": history-search-backward
"\e[6~": history-search-forward
"\e[3~": delete-char
"\e[2~": quoted-insert
"\e[5C": forward-word
"\e[5D": backward-word
"\e\e[C": forward-word
"\e\e[D": backward-word
"\e[1;5D": backward-word
"\e[1;5C": forward-word
set completion-ignore-case On
EOS
fi

if ! grep '^# Eternal bash history.$' ~/.bashrc; then
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
