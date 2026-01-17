# Source this file from your bashrc

export BASH_HELPERS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

HELPERS="alias vars path bm log prompt flatpak ssh"

load_script() {
    local name="$1"
    local base_script="$BASH_HELPERS/$name.sh"
    local platform_script

    if [ -n "$MSYSTEM" ]; then
        platform_script="$BASH_HELPERS/$name.windows.sh"
    else
        platform_script="$BASH_HELPERS/$name.linux.sh"
    fi

    if [ -f "$base_script" ]; then
        [ -n "$DEBUG" ] && echo "Sourcing $base_script"
        . "$base_script"
    fi

    if [ -f "$platform_script" ]; then
        [ -n "$DEBUG" ] && echo "Sourcing $platform_script"
        . "$platform_script"
    fi
}

for helper in $HELPERS; do
    load_script "$helper"
done
