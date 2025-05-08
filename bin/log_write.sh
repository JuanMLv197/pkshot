#!/bin/bash

source ./../comp.sh

line_start(){
	if [ $1 -eq 1 ]; then
		echo "[$(date +"%H:%M|%d-%m-%+4Y")]_${BASH_SOURCE[1]}:"
	elif [ $1 -eq 2 ]; then
		echo "[$(date +"%H:%M|%d-%m-%+4Y")]_${BASH_SOURCE[1]}_ERROR:"
	fi
}

pkshot_log_create(){
	echo "$(line_start 2) Log was unreachable or didnt exist yet, so it has been created." >> $LOG_FILE
}

pkshot_log_missing_conf(){
	file="$1"
	echo "$(line_start 2) $file is unreachable or doesnt exist, so the template has been copied. Check the new \"pkshot.conf\" file to make the necessary configurations" >> $LOG_FILE
} 

pkshot_log_param_compulsory(){
	echo "$(line_start 2) One of the compulsory variables is not found or not defined" >> $LOG_FILE
}

pkshot_log_param(){	
	param=$1
	case $param in
		1)
			"$(line_start 2) The \$TIME variable is not a number or is greater than 60 seconds, please check the pkshot.conf file." >> $LOG_FILE
			;;
		2)
			"$(line_start 2) The \$FORMAT variable is *not* set to one of the valid values, please check the pkshot.conf file." >> $LOG_FILE
			;;
		3)
			"$(line_start 2) The \$TIME variable is not a number or is greater than 60 seconds" >> $LOG_FILE
			;;
		4)
			"$(line_start 2) The \$TIME variable is not a number or is greater than 60 seconds" >> $LOG_FILE
			;;
		5)
			"$(line_start 2) The \$TIME variable is not a number or is greater than 60 seconds" >> $LOG_FILE
			;;
		6)
			"$(line_start 2) The \$TIME variable is not a number or is greater than 60 seconds" >> $LOG_FILE
			;;
	esac
}

pkshot_log_screenshot(){



}

pkshot_log_compression(){



}

pkshot_log_oe(){



}
