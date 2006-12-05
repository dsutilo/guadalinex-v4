#!/bin/sh

if [ `id -u` -eq 0 ];then

	if [ ! -d /usr/lib/flashplugin-nonfree/ ]; then

		zenity --question --title "Instalación de Macromedia Flash" --text "Se va a proceder a instalar el plugin de Macromedia Flash 9.\n\n Es necesario que esté conectado a Internet.\n\n¿Desea continuar?" && rm -rf /tmp/FP9_plugin_beta_112006.tar.gz && wget -nc -P /tmp http://download.macromedia.com/pub/labs/flashplayer9_update/FP9_plugin_beta_112006.tar.gz 2>&1 | zenity --progress --pulsate --title "Instalación de Macromedia Flash" --text "Descargando..." --auto-close && tar xfz /tmp/FP9_plugin_beta_112006.tar.gz -C /tmp && mkdir -p /usr/lib/flashplugin-nonfree && cp /tmp/flash-player-plugin-9.0.21.78/libflashplayer.so /usr/lib/flashplugin-nonfree && ln -sf /usr/lib/flashplugin-nonfree/libflashplayer.so /usr/lib/firefox/plugins

		if [ ! -f /usr/lib/flashplugin-nonfree/libflashplayer.so ]; then
			zenity --info --title "Instalación de Macromedia Flash" --text "Ha habido un error en la descarga. Inténtelo más tarde."
		else
			zenity --info --title "Instalación de Macromedia Flash" --text "Instalación completada con éxito."
		fi

	else
		zenity --info --title "Instalación de Macromedia Flash" --text "Ya tiene instalado el plugin de Macromedia Flash para Mozilla Firefox."

	fi
else
	gksudo $0;
fi
