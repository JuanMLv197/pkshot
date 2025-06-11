#!/bin/bash
#-------------------------PKSHOT-------------------------#
# Author: Juan Martínez Liarte #-------------------------#
# File Name: main.sh #-----------------------------------#
# Description: The principal script for the service #----#
#--------------------------------------------------------#

#Definimos la variable GRAPH_USER la cuál contiene el nombre
#del usuario que esta utilizando el display gráfico.
GRAPH_USER=$(w -oshu | xargs | cut -f1 -d" ")

#Se le dan permisos a root para interactuar con el display
#desde el usuario gráfico
sudo -u "$GRAPH_USER" DISPLAY=:0 xhost +SI:localuser:root

#Se exporta la autorización del usuario gráfico para root
export XAUTHORITY="/home/$GRAPH_USER/.Xauthority"

#Se llaman a todos los ficheros del proyecto para utilizarlos
source /etc/pkshot/pkshot.conf
source /etc/pkshot/bin/comp.sh
source /etc/pkshot/lib/log_write.sh
source /etc/pkshot/lib/screenshots.sh
source /etc/pkshot/lib/overeth.sh

#Se comprueba si la variable SCREENSHOTS_OE esta definida y
#en el caso de que sí se procede con su bucle:
if [ $SCREENSHOTS_OE ]; then
	
	#Bucle for-in que itera en el rango entre 1 y el valor
	#de la variable LIFETIME para determinar cuanto tiempo
	#tiene que estar vivo el servicio
	for i in $(seq 1 $LIFETIME); do
		
		#Se determinan los segundos de dentro de una hora
		#y empieza el bucle en el que se va a comprobar 
		#en cada iteración si ya ha pasado una hora, mientras
		#que no haya pasado se harán las capturas y se
		#esperará el intervalo determinado
		LIFETIME_wanted_seconds=$(( $(date +%s) + 3600 ))
		while true; do
			if [[ $(date +%s) -gt $LIFETIME_wanted_seconds ]]; then
				break 
			fi
			"take_$FORMAT"
			sleep $SCREENSHOT_INTERVAL
		done

		#Cuando la cantidad de segundos llega a la esperada
		#se rompe el bucle y se ejecutan en segundo plano
		#la compresión y el envío de las capturas
		(
			compress_screenshots
			send_screenshots
		) &
	done

	#Se espera a que terminen de ejecutarse todos los procesos
	#y entonces termina
	wait
else

	#En este caso es lo mismo que en el anterior bucle pero
	#no tenemos la ejecución en segundo plano de la compresión
	#y del envío
	for i in $(seq 1 $LIFETIME); do
		LIFETIME_wanted_seconds=$(( $(date +%s) + 3600 ))
		while true; do
			if [[ $(date +%s) -gt $LIFETIME_wanted_seconds ]]; then
				break 
			fi
			"take_$FORMAT"
			sleep $SCREENSHOT_INTERVAL
		done
	done
	wait
fi

#Se manda el mensaje de que ha terminado el servicio
pkshot_log_finish

#Se le revocan los permisos del display gráfico a root
sudo -u "$GRAPH_USER" DISPLAY=:0 xhost -SI:localuser:root
