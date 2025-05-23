#!/bin/bash


GRAPH_USER=$(w -oshu | xargs | cut -f1 -d" ")
sudo -u "$GRAPH_USER" DISPLAY=:0 xhost +SI:localuser:root
export XAUTHORITY="/home/$GRAPH_USER/.Xauthority"

source /home/juan/pkshot/pkshot.conf
source /home/juan/pkshot/bin/comp.sh
source /home/juan/pkshot/lib/log_write.sh
source /home/juan/pkshot/lib/screenshots.sh

LIFETIME_wanted_secs=$(( $LIFETIME * 60 ))
LIFETIME_current_secs=0

if [ "$FORMAT" = "xwd" ]; then
	func="take_xwd"
elif [ "$FORMAT" = "png" ]; then
	func="take_png"
elif [ "$FORMAT" = "jpg" ]; then
	func="take_jpg"
fi

while true; do
	if [ $(($LIFETIME_current_secs + $SCREENSHOT_INTERVAL )) -gt $LIFETIME_wanted_secs ]; then
		break 
	fi
	$func
	LIFETIME_current_secs=$(( $LIFETIME_current_secs + $SCREENSHOT_INTERVAL))
	sleep $SCREENSHOT_INTERVAL
done

pkshot_log_finish

sudo -u "$GRAPH_USER" DISPLAY=:0 xhost -SI:localuser:root
