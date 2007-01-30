#!/bin/bash

if [ `id -u` -eq 0 ];then

    dpkg-query -s flashplugin-nonfree|grep -q " installed"
    if [ "$?" -eq 1 ]; then
        echo "flashplugin-nonfree   install" | synaptic --hide-main-window --non-interactive --set-selections --progress-str "Instalando Plugin de Macromedia Flash" --finish-str "Plugin instalado"

    else
        zenity --info --title "Instalación de Macromedia Flash" --text "Ya tiene instalado el plugin de Macromedia Flash para Mozilla Firefox."
    fi
else
    gksudo $0;
fi

