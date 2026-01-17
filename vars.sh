if [ -n "$HISTIGNORE" ]; then
    export HISTIGNORE="$HISTIGNORE:ls:history"
else
    export HISTIGNORE="ls:history"
fi
