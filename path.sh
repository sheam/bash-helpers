if [ -z "$BASH_HELPERS" ]; then
	echo "BASH_HELPERS is not set, quitting"
	exit 1
fi

path_add() {
	if [[ -z "$1" ]]; then
		return
	fi

	local prepend=false
	if [[ "$1" == "-p" ]]; then
		prepend=true
		shift
	fi

	# Expand ~ to $HOME
	local path="${1/#\~/$HOME}"

	# Check if path exists as a directory
	if [[ ! -d "$path" ]]; then
		return
	fi

	# Check if already in PATH
	case ":$PATH:" in
		*":$path:"*) return ;;
	esac

	# Add to PATH
	if [[ $prepend ]]; then
		PATH="$path:$PATH"
	else
		PATH="$PATH:$path"
	fi
}

path_add "$BASH_HELPERS/bin"
path_add "$GOPATH/bin"
