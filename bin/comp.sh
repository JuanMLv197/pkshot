#!/bin/bash

source /home/juan/pkshot/lib/log_write.sh

LOG_FILE=/var/log/pkshot.log
CONF_FILE=/home/juan/pkshot/pkshot.conf
#CONF_FILE=/etc/pkshot/pkshot.conf

if ! [ -f $LOG_FILE ] 2>/dev/null; then
	touch $LOG_FILE
	pkshot_log_create $LOG_FILE
fi

if [ -f $CONF_FILE ] 2>/dev/null ; then
	source $CONF_FILE
else
	cp ./templates/pkshot_template.conf $CONF_FILE
	source $CONF_FILE
	pkshot_log_missing_conf $CONF_FILE
	exit 1
fi

if ! [ $LIFETIME ] && ! [ $SCREENSHOT_INTERVAL ] && ! [ $FORMAT ] && ! [ $SCREENSHOTS_DIRECTORY ]; then
	pkshot_log_param_compulsory
	exit 1
fi

if ! [ $LIFETIME -eq $LIFETIME ]; then
	pkshot_log_param 1
	exit 1
fi

if ! [ $SCREENSHOT_INTERVAL -eq $SCREENSHOT_INTERVAL ] 2>/dev/null || [ $SCREENSHOT_INTERVAL -ge 60 ]; then
	pkshot_log_param 2 
	exit 1
fi

if ! [ "$FORMAT" = "png" ] && ! [ "$FORMAT" = "jpg" ] && ! [ "$FORMAT" = "xwd" ]; then
	pkshot_log_param 3 
	exit 1
fi 

if [ "$FORMAT" = "jpg" ]; then
	if ! [ "$JPG_COMPRESSION_LEVEL" ] ; then
		pkshot_log_param 4 
		exit 1
	fi
	if ! [ "$JPG_COMPRESSION_LEVEL" -eq "$JPG_COMPRESSION_LEVEL" ] || ! $( [ "$JPG_COMPRESSION_LEVEL" -ge 50 ] && [ "$JPG_COMPRESSION_LEVEL" -le 100 ] ); then
	pkshot_log_param 5
	exit 1
	fi
fi

if [ $SCREENSHOTS_OE ] 2>/dev/null && ! [[ $SCREENSHOTS_OE =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
	pkshot_log_param 6	
	exit 1
fi

if ! [ -d $SCREENSHOTS_DIRECTORY ]; then
	pkshot_log_param 7 $SCREENSHOTS_DIRECTORY
	exit 1
fi

