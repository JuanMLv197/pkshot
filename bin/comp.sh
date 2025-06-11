#!/bin/bash
#-------------------------PKSHOT-------------------------#
# Author: Juan Martínez Liarte #-------------------------#
# File Name: bin/comp.sh #-------------------------------#
# Description: Previous comprobations for the script #---#
#--------------------------------------------------------#

#Llamada al fichero de funciones de log y al fichero de
#funciones de SCREENSHOTS_OE
source /etc/pkshot/lib/log_write.sh
source /etc/pkshot/lib/overeth.sh

#Declaración de las variables que contienen la ruta de los
#ficheros de log y configuración
LOG_FILE=/var/log/pkshot.log
CONF_FILE=/etc/pkshot/pkshot.conf

#Comprobación de que el fichero de log existe y sino se
#crea y se manda el mensaje.
if ! [ -f $LOG_FILE ] 2>/dev/null; then
	touch $LOG_FILE
	pkshot_log_create $LOG_FILE
fi

#Comprobación de que el fichero de configuración existe,
#en el caso de que sí lo llama y sino lo copia de la
#plantilla, se manda el mensaje y hace exit
if [ -f $CONF_FILE ] 2>/dev/null ; then
	source $CONF_FILE
else
	cp /etc/pkshot/templates/pkshot_template.conf $CONF_FILE
	source $CONF_FILE
	pkshot_log_missing_conf $CONF_FILE
	exit 1
fi

#Comprobación de que todas las variables obligatorias
#estén definidas y sino envia el mensaje y hace exit
if ! [ $LIFETIME ] && ! [ $SCREENSHOT_INTERVAL ] && ! [ $FORMAT ] && ! [ $SCREENSHOTS_DIRECTORY ]; then
	pkshot_log_param_compulsory
	exit 1
fi

#Comprobación de que la variable LIFETIME sea un 
#número y sino envia el mensaje y hace exit
if ! [ $LIFETIME -eq $LIFETIME ]; then
	pkshot_log_param 1
	exit 1
fi

#Comprobación de que la variable SCREENSHOT_INTERVAL
#sea un número y su valor sea menor a 60 y sino 
#envia el mensaje y hace exit
if ! [ $SCREENSHOT_INTERVAL -eq $SCREENSHOT_INTERVAL ] 2>/dev/null || [ $SCREENSHOT_INTERVAL -ge 60 ]; then
	pkshot_log_param 2 
	exit 1
fi

#Comprobación de que la variable FORMAT tiene un valor
#de entre los permitidosy sino envia el mensaje y 
#hace exit
if ! [ "$FORMAT" = "png" ] && ! [ "$FORMAT" = "jpg" ] && ! [ "$FORMAT" = "xwd" ]; then
	pkshot_log_param 3 
	exit 1
fi 

#Comprobación de que si la variable FORMAT esta
#definida a jpg, la variable JPG_COMPRESSION_LEVEL
#tiene que estar definida y sino envia el mensaje y hace exit
if [ "$FORMAT" = "jpg" ]; then
	if ! [ "$JPG_COMPRESSION_LEVEL" ] ; then
		pkshot_log_param 4 
		exit 1
	fi
	#Comprobación de que la variable es un número y si su
	#valor esta comprendido entre 50 y 100  y sino envía
	#el mensaje y hace exit
	if ! [ "$JPG_COMPRESSION_LEVEL" -eq "$JPG_COMPRESSION_LEVEL" ] || ! $( [ "$JPG_COMPRESSION_LEVEL" -ge 50 ] && [ "$JPG_COMPRESSION_LEVEL" -le 100 ] ); then
	pkshot_log_param 5
	exit 1
	fi
fi

#Comprobación de que la variable SCREENSHOTS_DIRECTORY 
#es un directorio y sino envía el mensaje y hace exit
if ! [ -d $SCREENSHOTS_DIRECTORY ]; then
	pkshot_log_param 6 $SCREENSHOTS_DIRECTORY
	exit 1
fi

if [ $SCREENSHOTS_OE ] 2>/dev/null; then

#Comprobación de que la variable SCREENSHOTS_OE es una
#IP bien formateada y sino envía el mensaje y hace exit
	if ! [[ $SCREENSHOTS_OE =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
		pkshot_log_oe 1	
		exit 1
	fi

#Comprobación de que el equipo remote es alcanzable
#y sino envía el mensaje y hace exit
	if ! test_oe; then
		pkshot_log_oe 2
		exit 1
	fi

#Comprobación de que se puede hacer login en el
#equipo remoto y sino envía el mensaje y hace exit
	if ! test_login; then
		pkshot_log_oe 3
		exit 1
	fi

#Comprobación de que existe el directorio del host
#en el equipo remoto y sino lo crea y envía el mensaje
	if ! test_remote_directories; then
		pkshot_log_oe 4
	fi
fi

