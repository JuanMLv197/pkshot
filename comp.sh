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

if ! [ $TIME -eq $TIME ] 2>/dev/null || [ $TIME -ge 60 ] 2>/dev/null; then
	pkshot_log_param 1 $TIME
	exit 1
fi

if ! [ "$FORMAT" = "png" ] && ! [ "$TIME" = "jpg" ]; then
	pkshot_log_param 2 $FORMAT
