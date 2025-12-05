BOOKMARK_FILE=~/.local/state/.cli_bookmarks
READ_OPTS=""
NI=0
LI=1
if [ $SHELL = "/bin/zsh" ]; then
    READ_OPTS="-A"
    NI=1
    LI=2
fi

#make sure that the directory of bm.rb is in your path
#source this file from your .profile file
function bm()
{
    _ensure_file
    if [ $# = 0 ] || [ "$1" = "-l" ]; then
        _print_bookmarks
        return $?
    fi

    if [ "$1" = "-h" ]; then
        _print_help
        return $?
    fi

    if [ "$1" = "-d" ]; then
        _delete_bookmark "$2"
        return $?
    fi

    if [ "$1" = "-s" ]; then
        _set_bookmark "$2"
        return $?
    fi

    if [ $# = 1 ]; then
        local D=$( _get_location_from_name $1 )
        if [ $? = 0 ]; then
            cd $D
            return 0
        else
            echo "ERROR"
            return 1
        fi
    fi

    _print_help
}

function _print_help()
{
    echo "To set a bookmark, cd to the directory you want to bookmark and then:"
    echo "    bm -s <NAME>"

    echo "To delete a bookmark:"
    echo "    bm -d <NAME>"

    echo "To CD to a directory by bookmark name:"
    echo "    bm <NAME>"

    echo "To print a list of bookmarks: "
    echo "    bm -l"

    echo "To print help: "
    echo "    bm -h"
}


function _ensure_file()
{
    if [ ! -f "$BOOKMARK_FILE" ]; then
        echo "Bookmark file $BOOKMARK_FILE not found. Creating."
				mkdir -p "$(dirname $BOOKMARK_FILE)"
        touch "$BOOKMARK_FILE"
    fi
}

function _print_bookmarks()
{
    echo ""
    printf "%-15s   %-60s\n" "BOOKMARK" "LOCATION"
    printf "%-15s   %-60s\n" "--------" "--------"
    while read $READ_OPTS LINE; do
        local PARTS=($LINE)
        local NAME=${PARTS[$NI]}
        local LOCATION=${PARTS[$LI]}
        printf "%-15s   %-60s\n" $NAME $LOCATION
    done < <(sort "$BOOKMARK_FILE")
    return 0
}

function _get_location_from_name() 
{
    local TARGET=$1
    while read $READ_OPTS LINE; do
        local PARTS=($LINE)
        local NAME=${PARTS[$NI]}
        local LOCATION=${PARTS[$LI]}
        if [ "$NAME" = "$TARGET" ]; then
            echo $LOCATION
            return 0
        fi
    done < "$BOOKMARK_FILE"
    return $NONE
    return -1
}

function _get_name_from_location() 
{
    local TARGET=$1
    while read $READ_OPTS LINE; do
        local PARTS=($LINE)
        local NAME=${PARTS[$NI]}
        local LOCATION=${PARTS[$LI]}
        if [ "$LOCATION" = "$TARGET" ]; then
            echo $NAME
            return 0
        fi
    done < "$BOOKMARK_FILE"
    echo $NONE
    return -1
}

function _set_bookmark()
{
    local NAME=$1
    local LOCATION=$PWD
    if [ -z "$NAME" ] || [ -z "$LOCATION" ]; then
        echo "set_bookmark requires two arguments, NAME LOCATION."
        return -11
    fi
    
    local EXISTING_LOCATION="$( _get_location_from_name $NAME)"
    if [ ! -z "$EXISTING_LOCATION" ]; then
        echo "The bookmark named '$NAME' is already used to bookmarked'$EXISTING_LOCATION'. Delete before replacing (use 'bm -d $NAME')."
        return -1
    fi
    
    local EXISTING_NAME="$( _get_name_from_location $LOCATION)"
    if [ ! -z "$EXISTING_NAME" ]; then
        echo "'$LOCATION' is already bookmarked under the name '$EXISTING_NAME'. Delete before replacing (use 'bm -d $EXISTING_NAME')."
        return -1
    fi

    echo -e "$NAME\t\t$LOCATION" >> $BOOKMARK_FILE
    return 0
}

function _delete_bookmark()
{
    local TARGET=$1
    if [ -z "$TARGET" ]; then
        echo "delete_bookmark requires a parameter NAME"
        return -1
    fi

    local TMP=/tmp/cli_bookmarks
    rm -f $TMP
    touch $TMP
    while read $READ_OPTS LINE; do
        local PARTS=($LINE)
        local NAME=${PARTS[$NI]}
        local LOCATION=${PARTS[$LI]}
        if [ "$NAME" = "$TARGET" ]; then
            echo "removed $NAME ($LOCATION)"
        else
            echo -e "$NAME\t\t$LOCATION" >> $TMP
        fi
    done < "$BOOKMARK_FILE"
    sort $TMP > $BOOKMARK_FILE
}
