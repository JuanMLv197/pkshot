#!/bin/bash
#-------------------------PKSHOT-------------------------#
# Author: Juan Martínez Liarte #-------------------------#
# File Name: lib/overeth.sh #----------------------------# 
# Description: Functions for the SCREENSHOTS_OE feat. #--#
#--------------------------------------------------------#

#Llamada al fichero de configuración y a las funciones
#de log

source /etc/pkshot/pkshot.conf
source /etc/pkshot/lib/log_write.sh

#Declaración de la ruta del directorio remoto del equipo
SCREENSHOTS_DIRECTORY_OE="screenshots/$(hostname)"

#Función que comprueba que la IP especificada es alcanzable
test_oe(){
	ping -q -c1 -W1 "$SCREENSHOTS_OE" >>/dev/null
}

#Función que recibe un comando y utilizando sshpass y ssh
#lo ejecuta en la máquina remota (sdc)
login_oe(){
	com="$1"
	sshpass -p "$SCREENSHOTS_OE_passwd" ssh -o StrictHostKeyChecking=no pkshot@"${SCREENSHOTS_OE}" "$com"
}

#Función que comprueba que el login en el equipo remoto
#se puede hacer
test_login(){
	com="exit"
	login_oe "$com"
}

#Función que comprueba que el directorio del host existe
#en el equipo remoto (sdc)
test_remote_directories(){
	com="[ -d $SCREENSHOTS_DIRECTORY_OE ] >>/dev/null || mkdir -p $SCREENSHOTS_DIRECTORY_OE"
	login_oe "$com"
}

#Función que comprime todas las capturas del directorio
#de almacenamiento y copia el comprimido al terminar a
#ese mismo directorio de almacenamiento de las capturas
compress_screenshots(){
	tgzname="/tmp/$(date +%s).tgz"
	tar czf "$tgzname" -C "$SCREENSHOTS_DIRECTORY" $(ls $SCREENSHOTS_DIRECTORY)
	cp "$tgzname" "$SCREENSHOTS_DIRECTORY"
}

#Función que copia el comprimido de las capturas, para
#más tarde descomprimirlo, borrar el comprimido y 
#borrar las capturas en el host
send_screenshots(){
	sshpass -p "$SCREENSHOTS_OE_passwd" scp -o StrictHostKeyChecking=no "$tgzname" "pkshot@${SCREENSHOTS_OE}:${SCREENSHOTS_DIRECTORY_OE}/."
	com="tar xzf $SCREENSHOTS_DIRECTORY_OE/$(basename $tgzname) -C $SCREENSHOTS_DIRECTORY_OE; rm $SCREENSHOTS_DIRECTORY_OE/*.tgz"
	login_oe "$com"
	screenshots="$SCREENSHOTS_DIRECTORY/*.$FORMAT"
	rm $screenshots $tgzname
	unset tgzname
}


