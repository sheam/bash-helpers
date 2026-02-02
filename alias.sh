alias vi=nvim
alias nv=nvim
alias vim=nvim
alias qi=nvim-qt
alias vv=nvim-qt
alias lg=lazygit

alias yz=yazi
function yzd() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	command yazi "$@" --cwd-file="$tmp" 
	if cwd="$(cat "$tmp")"; then 
		[ -d "$cwd" ] && cd "$cwd"
	fi
	rm -f "$tmp"
}
