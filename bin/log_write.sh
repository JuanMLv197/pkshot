#!/bin/bash

source ./../comp.sh

line_start(){
	echo "[$(date +"%H:%M|%d-%m-%+4Y")]_${BASH_SOURCE[1]}:"
}

pkshot_log_create(){
	echo "$(line_start) Log was unreachable or didnt exist yet, so it has been created." > $LOG_FILE
}

pkshot_log_missing_conf(){
	file=$1
	echo "$(line_start) $file is unreachable or doesnt exist, so the template has been copied. Check the new \"pkshot.conf\" file to make the necessary configurations" > $LOG_FILE
} 

pkshot_log_param(){

	

}

pkshot_log_screenshot(){



}

pkshot_log_compression(){



}

pkshot_log_oe(){



}
