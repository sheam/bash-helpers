if [ -z "$BASH_HELPERS" ]; then
	echo "BASH_HELPERS is not set, quitting"
	exit 1
fi


export PATH="$PATH:$BASH_HELPERS/bin"
if [ -n "$GOPATH" ]; then
    export PATH="$PATH:$GOPATH/bin"
fi