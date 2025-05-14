#!/bin/bash

source ./pkshot.conf
source ./bin/comp.sh
source ./lib/log_write.sh
source ./lib/screenshots.sh

LIFETIME_wanted_secs=$(( $LIFETIME * 60 ))
LIFETIME_current_secs=0

if [ "$FORMAT" = "xwd" ]; then
	func="take_xwd"
elif [ "$FORMAT" = "png" ]; then
	func="take_png"
elif [ "$FORMAT" = "jpg" ]; then
	func="take_jpg"
fi

while [ $LIFETIME_current_secs -lt $LIFETIME_wanted_secs ]; do
	$func
	LIFETIME_current_secs=$(( $LIFETIME_current_secs + $SCREENSHOT_INTERVAL))
	sleep $SCREENSHOT_INTERVAL
done


