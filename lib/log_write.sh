#!/bin/bash

line_start(){
	if [ $1 -eq 1 ]; then
		echo "[$(date +"%H:%M:%S|%d-%m-%Y")]->${BASH_SOURCE[1]}:"
	elif [ $1 -eq 2 ]; then
		echo "[$(date +"%H:%M:%S|%d-%m-%Y")]->${BASH_SOURCE[1]}_ERROR:"
	elif [ $1 -eq 3 ]; then
		echo "[$(date +"%H:%M:%S|%d-%m-%Y")]"
	fi
}

msg_send(){
	if [ "$1" = "info" ]; then
		echo "$2" >> "$LOG_FILE"
		logger -t pkshot "$2" 
	elif [ "$1" = "warning" ]; then
		echo "$2" >> "$LOG_FILE"
		logger -p user.warning -t pkshot "$2" 
	elif [ "$1" = "error" ]; then
		echo "$2" >> "$LOG_FILE"
		logger -p user.err -t pkshot "$2" 
	fi
}

pkshot_log_create(){
	local msg="$(line_start 2) Log was unreachable or didnt exist yet, so it has been created."
	msg_send "warning" "$msg"
}

pkshot_log_missing_conf(){
	local file="$1"
	local msg="$(line_start 2) $file is unreachable or doesnt exist, so the template has been copied. Check the new \"pkshot.conf\" file to make the necessary configurations"
	msg_send "warning" "$msg"
} 

pkshot_log_param_compulsory(){
	local msg="$(line_start 2) One of the compulsory variables is not found, not defined or with no value." 
	msg_send "error" "$msg"
}

pkshot_log_param(){	
	local param=$1
	case $param in
		1)
			local msg="$(line_start 2) The \$LIFETIME variable is not a number, please check the pkshot.conf file"
			;;
		2)
			local msg="$(line_start 2) The \$SCREENSHOT_INTERVAL variable is not a number or is greater than 60 seconds, please check the pkshot.conf file."
			;;
		3)
			local msg="$(line_start 2) The \$FORMAT variable is *not* set to one of the valid values, please check the pkshot.conf file."
			;;
		4)
			local msg="$(line_start 2) As the \$FORMAT variable is set to \"jpg\", the \$JPG_COMPRESSION_LEVEL variable must be set, please check the pkshot.conf file."
			;;
		5)
			local msg="$(line_start 2) The \$JPG_COMPRESSION_LEVEL variable is not a number or is not between the range of values, please check the pkshot.conf file."
			;;
		6)
			local msg="$(line_start 2) The \$SCREENSHOTS_OE variable value does not match an IP valid format, please check the pkshot.conf file."
			;;
		7)
			local msg="$(line_start 2) $2 is not accesible or it is not a directory."
			;;
	esac
	msg_send "error" "$msg"
}

pkshot_log_screenshot(){
	local msg="$(line_start 1) Screenshot has been taken."
	msg_send "info" "$msg"
}

pkshot_log_start(){
	local msg="$(line_start 1) Pkshot has started its cicle."
	msg_send "info" "$msg"
}

pkshot_log_finish(){
	local msg="$(line_start 1) Pkshot has finished the specified time cicle, check the screenshots at $SCREENSHOTS_DIRECTORY."
	msg_send "info" "$msg"
}

#pkshot_log_compression(){
#}

#pkshot_log_oe(){
#}
