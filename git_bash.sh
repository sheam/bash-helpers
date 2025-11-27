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

PREFIX='${debian_chroot:+($debian_chroot)}\n'
PREFIX+="\[$COLOR_BLUE\]\\w\[$COLOR_RESET\]\n"
#PREFIX+="\[$COLOR_RED\]"

POSTFIX=""
#POSTFIX+="\[$COLOR_RESET\]"
POSTFIX+="\[$COLOR_WHITE\]\\$\[$COLOR_RESET\] "


##PS1=
#PROMPT_COMMAND="$(__git_ps1) $PREFIX' '$POSTFIX"
#PS1='$(__git_ps1 "$PREFIX" "$POSTFIX")'

__build_prompt() {
	PS1=""
	PS1+="\[$COLOR_BLUE\]\\w\[$COLOR_RESET\]\n"
	PS1+="\[$COLOR_GREEN\]\$(__git_ps1 '(%s)')\[$COLOR_RESET\]"
	PS1+="\[$COLOR_WHITE\]\\$\[$COLOR_RESET\] "
}

PROMPT_COMMAND="__build_prompt"

# PS1+="\[$COLOR_BLUE\]\\w\[$COLOR_RESET\]\n"
# PS1+="\[$COLOR_GREEN\]\$(__git_ps1 '(%s)')\[$COLOR_RESET\]"
# PS1+="\[$COLOR_WHITE\]\\$\[$COLOR_RESET\] "
