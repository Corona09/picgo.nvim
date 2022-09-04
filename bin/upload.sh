#!/usr/bin/env bash

datetime=`date "+%Y-%m-%d_%H-%M-%S"`
if [ $# -le 0 ]; then
	tmpfile=`mktemp -t "$datetime.XXXXXXXXX" --suffix ".png"`
else
	bname=`basename $1`
	tmpfile=`mktemp -t "$datetime.XXXXXXXXX.$bname"`
fi

if [ $# -le 0 ]; then
	if [ $XDG_SESSION_TYPE = "wayland" ]; then
		wl-paste --no-newline --type image/png > $tmpfile
	elif [ $XDG_SESSION_TYPE = "x11" ]; then
		xclip -selection clipboard -t image/png -o > $tmpfile
	fi
else
	cp "$1" "$tmpfile"
fi

result=`picgo u $tmpfile`
rm -f $tmpfile
echo $result
