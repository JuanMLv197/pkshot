#!/bin/bash
#-------------------------PKSHOT-------------------------#
# Author: Juan Martínez Liarte #-------------------------#
# File Name: lib/overeth.sh #----------------------------# 
# Description: Functions for the SCREENSHOTS_OE feat. #--#
#--------------------------------------------------------#

source /home/juan/pkshot/pkshot.conf
source /home/juan/pkshot/lib/log_write.sh

SCREENSHOTS_DIRECTORY_OE="screenshots/$(hostname)"

test_oe(){
	ping -q -c1 -W1 "$SCREENSHOTS_OE" >>/dev/null || exit 1
}

login_oe(){
	com="$1"
	sshpass -p "$SCREENSHOTS_OE_passwd" ssh pkshot@"${SCREENSHOTS_OE}" "$com"
}

test_login(){
	com="exit"
	login_oe "$com" || exit 1
}

test_remote_directories(){
	com="[ -d $SCREENSHOTS_DIRECTORY_OE ] >>/dev/null || mkdir -p $SCREENSHOTS_DIRECTORY_OE"
	login_oe "$com"
}

compress_screenshots(){
	tgzname="/tmp/$(date +%s).tgz"
	tar czf "$tgzname" -C "$SCREENSHOTS_DIRECTORY" $(ls $SCREENSHOTS_DIRECTORY)
	cp "$tgzname" "$SCREENSHOTS_DIRECTORY"
}

send_screenshots(){
	sshpass -p "$SCREENSHOTS_OE_passwd" scp -o StrictHostKeyChecking=no "$tgzname" "pkshot@${SCREENSHOTS_OE}:${SCREENSHOTS_DIRECTORY_OE}/."
	com="tar xzf $SCREENSHOTS_DIRECTORY_OE/$(basename $tgzname) -C $SCREENSHOTS_DIRECTORY_OE; rm $SCREENSHOTS_DIRECTORY_OE/*.tgz"
	login_oe "$com"
	unset tgzname
	screenshots="$SCREENSHOTS_DIRECTORY/*.$FORMAT"
	rm $screenshots $tgzname
}


