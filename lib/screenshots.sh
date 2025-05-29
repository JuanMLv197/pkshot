#!/bin/bash
#-------------------------PKSHOT-------------------------#
# Author: Juan Martínez Liarte #-------------------------#
# File Name: lib/screenshots.sh #------------------------#                                                                                             
# Description: Functions for taking the screenshots #----#                                                                                             
#--------------------------------------------------------#

source /home/juan/pkshot/pkshot.conf
source /home/juan/pkshot/lib/log_write.sh

screenshot_name(){
	if [ $1 -eq 1 ]; then
		echo "$(line_start 4)_$(w -oshu | awk -F " " '{print $1}' | head -1)_$HOSTNAME"
	elif [ $1 -eq 2 ]; then
		echo "$(line_start 4)_$(w -oshu | awk -F " " '{print $1}' | head -1)_${HOSTNAME}_$JPG_COMPRESSION_LEVEL"
	fi
}

take_xwd(){
	local path="$SCREENSHOTS_DIRECTORY/$(screenshot_name 1).xwd"
	xwd -root > "$path"
	pkshot_log_screenshot
}

take_png(){
	local path="$SCREENSHOTS_DIRECTORY/$(screenshot_name 1).png"
	import -window root "$path" 
	pkshot_log_screenshot
}

take_jpg(){
	local path="$SCREENSHOTS_DIRECTORY/$(screenshot_name 2).jpg"
	import -window root -quality "$JPG_COMPRESSION_LEVEL" "$path" 
	pkshot_log_screenshot
}
