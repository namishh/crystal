#!/usr/bin/env sh

cleanup() {
	# Clean up the tempdir if and only if we created it.
	if [ "$cleanup_tempdir" = "1" ]; then
		rm -r "$LF_TEMPDIR" 2>/dev/null
	fi
	kill $ueberzugpid 2>/dev/null
}

# Set up a temporary directory if not alreay done so by a calling
# wrapper script (e.g. lfcd).
if [ -z "$LF_TEMPDIR" ]; then
	cleanup_tempdir=1
	export LF_TEMPDIR="$(mktemp -d -t lf-tempdir-XXXXXX)"
fi

trap cleanup INT

export LF_FIFO_UEBERZUG="$LF_TEMPDIR/fifo"
mkfifo "$LF_FIFO_UEBERZUG"
tail -f "$LF_FIFO_UEBERZUG" | ueberzug layer --silent &
ueberzugpid=$!
lf "$@"
cleanup
