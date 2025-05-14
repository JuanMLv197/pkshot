#!/bin/bash

clear

while true; do
    read -n 1 key
    case $key in
        1)
            tput sc
			tput rc
			;;
		q)
			clear
			stty echo
			exit
	esac
done
