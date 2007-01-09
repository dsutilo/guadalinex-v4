#!/bin/sh

if [ `id -u` -eq 0 ];then
	dpkg -l w32codecs > /dev/null 2>&1;
	if [ $? -ne 0 ]; then

		zenity --question --title "Instalación de codecs" --text "Se va a proceder a instalar los codecs privativos.\n\n Es necesario que esté conectado a Internet.\n\n¿Desea continuar?" && rm -rf /tmp/w32codecs*.deb && wget -nc -P /tmp http://seveas.imbrandon.com/pool/edgy-seveas/extras/w32codecs_20060611-0.0_i386.deb 2>&1 | zenity --progress --pulsate --title "Instalación de codecs privativos" --text "Descargando 14 MB...\n\nEsto llevará un rato." --auto-close && dpkg -i /tmp/w32codecs_20060611-0.0_i386.deb && rm /tmp/w32codecs_20060611-0.0_i386.deb
		dpkg -l w32codecs > /dev/null 2>&1;
		if [ $? -ne 0 ]; then
			zenity --info --title "Instalación de codecs" --text "Ha habido un error en la descarga. Inténtelo más tarde."
			rm -rf /tmp/w32codecs_20060611-0.0_i386.deb
		else
			zenity --info --title "Instalación de codecs" --text "Instalación completada con éxito."
		fi

	else
		zenity --info --title "Instalación de codecs" --text "Ya tiene instalados los codecs privativos."

	fi
else
	gksudo $0;
fi
