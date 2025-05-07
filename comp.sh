#!/bin/bash

source ./bin/log_write.sh
source ./pkshot.conf

LOG_FILE=/var/log/pkshot.log
CONF_FILE=./pkshot.conf
#CONF_FILE=/etc/pkshot/pkshot.conf

if ! [ -f $LOG_FILE ] 2>/dev/null; then
	touch $LOG_FILE
	pkshot_log_create $LOG_FILE
fi

if [ -f $CONF_FILE ] 2>/dev/null ; then
	source $CONF_FILE
else
	cp ./template/pkshot_template.conf $CONF_FILE
	pkshot_log_missing_conf $CONF_FILE
	exit 1
fi

if ! [ $TIME ] || ! [ $FORMAT ]

if ! [ $TIME -eq $TIME ] 2>/dev/null || [ $TIME -ge 60 ]; then
	pkshot_log_param 1 
	exit 1
fi

if ! [ "$FORMAT" = "png" ] && ! [ "$FORMAT" = "jpg" ]; then
	pkshot_log_param 2 
	exit 1
fi 

if [ "$FORMAT" = "jpg" ] && ! [ "$JPG_COMPRESSION_LEVEL" ] ; then
	pkshot_log_param 3 
	exit 1
fi

if ! [ "$JPG_COMPRESSION_LEVEL" -eq "$JPG_COMPRESSION_LEVEL" ] || ! $( [ "$JPG_COMPRESSION_LEVEL" -ge 50 ] && [ "$JPG_COMPRESSION_LEVEL" -le 100 ] ); then
	pkshot_log_param 4
	exit 1
fi

if [ $SCREENSHOTS_OE ] && ! [[ $SCREENSHOTS_OE = =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
	pkshot_log_param 5	
	exit 1
fi

if ! [ -d $SCREENSHOTS_DIRECTORY ]; then
	pkshot_log_param 6
	exit 1
fi

if ! [  ]

