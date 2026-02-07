function yzd() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	command yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat "$tmp")"; then
		[ -d "$cwd" ] && cd "$cwd"
	fi
	rm -f "$tmp"
}

alias less='glow -p'
alias g=glow
