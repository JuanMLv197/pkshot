#!/bin/bash

#source ../comp.sh

line_start(){
	if [ $1 -eq 1 ]; then
		echo "[$(date +"%H:%M:%S|%d-%m-%Y")]_${BASH_SOURCE[1]}:"
	elif [ $1 -eq 2 ]; then
		echo "[$(date +"%H:%M:%S|%d-%m-%Y")]_${BASH_SOURCE[1]}_ERROR:"
	elif [ $1 -eq 3 ]; then
		echo "[$(date +"%H:%M:%S|%d-%m-%Y")]"
	fi
}

pkshot_log_create(){
	echo "$(line_start 2) Log was unreachable or didnt exist yet, so it has been created." >> "$LOG_FILE"
}

pkshot_log_missing_conf(){
	file="$1"
	echo "$(line_start 2) $file is unreachable or doesnt exist, so the template has been copied. Check the new \"pkshot.conf\" file to make the necessary configurations" >> "$LOG_FILE"
} 

pkshot_log_param_compulsory(){
	echo "$(line_start 2) One of the compulsory variables is not found, not defined or with no value." >> "$LOG_FILE"
}

pkshot_log_param(){	
	param=$1
	case $param in
		1)
			echo "$(line_start 2) The \$LIFETIME variable is not a number, please check the pkshot.conf file"
			;;
		2)
			echo "$(line_start 2) The \$SCREENSHOT_INTERVAL variable is not a number or is greater than 60 seconds, please check the pkshot.conf file." >> "$LOG_FILE"
			;;
		3)
			echo "$(line_start 2) The \$FORMAT variable is *not* set to one of the valid values, please check the pkshot.conf file." >> "$LOG_FILE"
			;;
		4)
			echo "$(line_start 2) As the \$FORMAT variable is set to \"jpg\", the \$JPG_COMPRESSION_LEVEL variable must be set, please check the pkshot.conf file." >> "$LOG_FILE"
			;;
		5)
			echo "$(line_start 2) The \$JPG_COMPRESSION_LEVEL variable is not a number or is not between the range of values, please check the pkshot.conf file." >> "$LOG_FILE"
			;;
		6)
			echo "$(line_start 2) The \$SCREENSHOTS_OE variable value does not match an IP valid format, please check the pkshot.conf file." >> "$LOG_FILE"
			;;
		7)
			echo "$(line_start 2) $2 is not accesible or it is not a directory." >> "$LOG_FILE"
			;;
	esac
}

pkshot_log_screenshot(){
	local file="$1"
	echo "$(line_start 1) The screenshot $file has been taken." >> "$LOG_FILE"
}

#pkshot_log_compression(){
#}

#pkshot_log_oe(){
#}
