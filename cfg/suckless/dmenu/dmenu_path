#!/bin/sh

cachedir="${XDG_CACHE_HOME:-"$HOME/.cache"}"
cache="$cachedir/dmenu_run"

[ ! -e "$cachedir" ] && mkdir -p "$cachedir"

IFS=:
if stest -dqr -n "$cache" $PATH; then
	stest -flx $PATH | sort -u | tee "$cache"
else
	cat "$cache"
fi
