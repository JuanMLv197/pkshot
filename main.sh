#!/bin/bash
#-------------------------PKSHOT-------------------------#
# Author: Juan Martínez Liarte #-------------------------#
# File Name: main.sh #-----------------------------------#
# Description: The principal script for the service #----#
#--------------------------------------------------------#

GRAPH_USER=$(w -oshu | xargs | cut -f1 -d" ")
sudo -u "$GRAPH_USER" DISPLAY=:0 xhost +SI:localuser:root
export XAUTHORITY="/home/$GRAPH_USER/.Xauthority"

source /etc/pkshot/pkshot.conf
source /etc/pkshot/bin/comp.sh
source /etc/pkshot/lib/log_write.sh
source /etc/pkshot/lib/screenshots.sh
source /etc/pkshot/lib/overeth.sh

if [ $SCREENSHOTS_OE ]; then
	for i in $(seq 1 $LIFETIME); do
		LIFETIME_wanted_seconds=$(( $(date +%s) + 3600 ))
		while true; do
			if [[ $(date +%s) -gt $LIFETIME_wanted_seconds ]]; then
				break 
			fi
			"take_$FORMAT"
			sleep $SCREENSHOT_INTERVAL
		done
		(
			compress_screenshots
			send_screenshots
		) &
	done
	wait
else
	for i in $(seq 1 $LIFETIME); do
		LIFETIME_wanted_seconds=$(( $(date +%s) + 3600 ))
		while true; do
			if [[ $(date +%s) -gt $LIFETIME_wanted_seconds ]]; then
				break 
			fi
			"take_$FORMAT"
			sleep $SCREENSHOT_INTERVAL
		done
	done
	wait
fi


pkshot_log_finish

sudo -u "$GRAPH_USER" DISPLAY=:0 xhost -SI:localuser:root
