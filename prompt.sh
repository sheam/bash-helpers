if [ -n "$STARSHIP_SHELL" ]; then
    return
fi

COLOR_RED="\033[01;31m"
COLOR_YELLOW="\033[01;33m"
COLOR_GREEN="\033[01;32m"
COLOR_OCHRE="\033[38;5;95m"
COLOR_BLUE="\033[01;34m"
COLOR_WHITE="\033[01;37m"
COLOR_RESET="\033[0m"

. /usr/lib/git-core/git-sh-prompt
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWDIRTYSTATE=1

# PREFIX='${debian_chroot:+($debian_chroot)}\n'
# PREFIX+="\[$COLOR_BLUE\]\\w\[$COLOR_RESET\]\n"
#PREFIX+="\[$COLOR_RED\]"

# POSTFIX=""
#POSTFIX+="\[$COLOR_RESET\]"
# POSTFIX+="\[$COLOR_WHITE\]\\$\[$COLOR_RESET\] "


##PS1=
#PROMPT_COMMAND="$(__git_ps1) $PREFIX' '$POSTFIX"
#PS1='$(__git_ps1 "$PREFIX" "$POSTFIX")'

__build_prompt() {
	PS1=""

	local CONTAINER=""
	if [[ -n $CONTAINER_ID ]]; then
		CONTAINER="\[$COLOR_YELLOW\]$CONTAINER_ID\[$COLOR_RESET\]: "
	fi

	local WORK_DIR="\[$COLOR_BLUE\]\\w\[$COLOR_RESET\]"

	PS1="\n$CONTAINER$WORK_DIR\n"

	# Get repository name and branch
	local GIT_INFO=""
	if git rev-parse --is-inside-work-tree &>/dev/null; then
		local repo_name=""
		local git_info=""
		repo_name=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
		git_info=$(__git_ps1 '%s')
		if [ -n "$git_info" ]; then
			GIT_INFO="\[$COLOR_OCHRE\][${repo_name}]\[$COLOR_GREEN\](${git_info})\[$COLOR_RESET\]"
		fi
	fi

	local PROMPT="\[$COLOR_WHITE\]\\$\[$COLOR_RESET\] "

	PS1="\n$CONTAINER$WORK_DIR\n$GIT_INFO$PROMPT"
}

PROMPT_COMMAND="__build_prompt"

# PS1+="\[$COLOR_BLUE\]\\w\[$COLOR_RESET\]\n"
# PS1+="\[$COLOR_GREEN\]\$(__git_ps1 '(%s)')\[$COLOR_RESET\]"
# PS1+="\[$COLOR_WHITE\]\\$\[$COLOR_RESET\] "
