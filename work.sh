#!/bin/bash
set -x
set -e
set -u 

./user_common.sh

if [ -z $(git config --global user.email) ]; then
	git config --global user.email "dnuffer@ancestry.com"
fi

