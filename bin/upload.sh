#!/usr/bin/env bash

datetime=`date "+%Y-%m-%d_%H-%M-%S"`
tmpfile=`mktemp -t "$datetime.XXXXXXXXX" --suffix ".png"`
echo $tmpfile

if [ $XDG_SESSION_TYPE = "wayland" ]; then
	wl-paste --no-newline --type image/png > $tmpfile
elif [ $XDG_SESSION_TYPE = "x11" ]; then
	wl-paste --no-newline --type image/png > $tmpfile
fi

result=`picgo u $tmpfile`
echo $result
