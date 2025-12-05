unset -f log
log() {
	# Check if LOG environment variable is set
	if [ -z "$LOG" ]; then
		echo "Error: LOG environment variable is not set" >&2
		return 1
	fi

	# Check if a command was provided
	if [ $# -eq 0 ]; then
		echo "The log file is currently set to $LOG."
		echo "Supply a command to log to the file."
		return 0
	fi

	# make sure we own the file in case sudo is being used
	touch $LOG

	# Log the command being executed
	echo "$ $*" >> "$LOG"

	# Execute the command, piping output to both terminal and logfile
	"$@" 2>&1 | tee -a "$LOG"

	# Preserve the exit status of the actual command, not tee
	return "${PIPESTATUS[0]}"
}

unset -f logcopy

logcopy() {
	if [ -z "$LOG" ]; then
		echo "Error: LOG environment variable is not set" >&2
		return 1
	fi
	if [ ! -f "$LOG" ]; then
		echo "No log contents at $LOG"
		return 0
	fi
	wl-copy < "$LOG"
	echo "copied $(wc -l < "$LOG") lines from $LOG to the clipboard"
}

unset -f logclear
logclear() {
	if [ -z "$LOG" ]; then
		echo "Error: LOG environment variable is not set" >&2
		return 1
	fi
	if [ ! -f "$LOG" ]; then
		echo "The file $LOG does not exist, there is nothing to delete."
		return 1
	fi
	rm -f $LOG
	echo "removed $LOG"
}

unset -f logset
logset() {
	if [ -z "$1" ]; then
		echo "Error: specify a name for the log file or a path to a log file." >&2
		echo "       - if a path is not specified, it will be placed in ~/logs." >&2
		echo "       - if a file extension is not specified, .log will be used." >&2
		return 1
	fi

	# if no path specified, put it in the ~/logs folder
	if [[ "$1" =~ ^[./] ]]; then
		NEWLOG="$1"
	else
		mkdir -p "$HOME/logs"
		NEWLOG="$HOME/logs/$1"
	fi

	# if no file extension then use .log
	if [[ ! "$NEWLOG" =~ \.[^./]+$ ]]; then
		NEWLOG="${NEWLOG}.log"
	fi

	if [ -f "$NEWLOG" ]; then
		echo "Warning: the file $NEWLOG already exists."
		echo " Make sure to clear it using logclear if you want it to start fresh."
	fi

	export LOG="$NEWLOG"
	echo "set LOG to $LOG"
}
