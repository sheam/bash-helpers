# Switch kitty theme in distrobox containers
if [ -n "$CONTAINER_ID" ] && [ "$TERM" = "xterm-kitty" ]; then
    kitty @ --to unix:/tmp/kitty-${KITTY_PID} set-colors --all ~/.config/kitty/solarized-dark.conf
fi
