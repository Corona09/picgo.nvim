#!/usr/bin/env bash

datetime=`date "+%Y-%m-%d_%H-%M-%S"`
tmpfile=`mktemp -t "$datetime.XXXXXXXXX" --suffix ".png"`
echo $tmpfile

if [ $XDG_SESSION_TYPE = "wayland" ]; then
	wl-paste --no-newline --type image/png > $tmpfile
elif [ $XDG_SESSION_TYPE = "x11" ]; then
	xclip -selection clipboard -t image/png -o > $tmpfile
fi

result=`picgo u $tmpfile`
echo $result
