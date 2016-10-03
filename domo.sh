#!/bin/sh
if ! grep 'src/tools/sid.sh' ~/.bashrc; then
cat >> ~/.bashrc << EOS
. \$HOME/src/tools/sid.sh
EOS
fi


if ! grep '^export PATH="$PATH:$HOME/src/domovm$"' ~/.bashrc; then
cat >> ~/.bashrc << EOS
export PATH="\$PATH:\$HOME/src/domovm"
EOS
fi

if ! grep '^Host domovm$' ~/.ssh/config; then
cat >> ~/.ssh/config << EOS

Host domovm
	User ubuntu
	Hostname domovm.local.domo.com
	IdentityFile /Users/dannuffer/src/domovm/ansible/roles/common/files/integration-testing
	UserKnownHostsFile=/dev/null
	StrictHostKeyChecking no

Host *
	StrictHostKeyChecking no

EOS
fi


