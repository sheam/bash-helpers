export EDITOR=nvim
export SSH_ASKPASS=/usr/bin/ksshaskpass
export SSH_ASKPASS_REQUIRE=prefer

if [ -z "$BASH_HELPERS" ]; then
	echo "BASH_HELPERS is not set, quitting"
	exit 1
fi
export PATH="$PATH:$BASH_HELPERS/bin"

HISTIGNORE="ls:history"
