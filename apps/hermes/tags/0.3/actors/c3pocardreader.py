#!/usr/bin/python
# -*- coding: utf-8 -*-

#Módulo c3pocardreader- Módulo que implementa el "actor hardware" para los
#lectores de tarjetas ltc31 de C3PO.
#
#Copyright (C) 2005 Junta de Andalucía
#
#Autor/es (Author/s):
#
#- Gumersindo Coronel Pérez <gcoronel@emergya.info>
#
#Este fichero es parte de Detección de Hardware de Guadalinex 2005 
#
#Detección de Hardware de Guadalinex 2005  es software libre. Puede redistribuirlo y/o modificarlo 
#bajo los términos de la Licencia Pública General de GNU según es 
#publicada por la Free Software Foundation, bien de la versión 2 de dicha
#Licencia o bien (según su elección) de cualquier versión posterior. 
#
#Detección de Hardware de Guadalinex 2005  se distribuye con la esperanza de que sea útil, 
#pero SIN NINGUNA GARANTÍA, incluso sin la garantía MERCANTIL 
#implícita o sin garantizar la CONVENIENCIA PARA UN PROPÓSITO 
#PARTICULAR. Véase la Licencia Pública General de GNU para más detalles. 
#
#Debería haber recibido una copia de la Licencia Pública General 
#junto con Detección de Hardware de Guadalinex 2005 . Si no ha sido así, escriba a la Free Software
#Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA.
#
#-------------------------------------------------------------------------
#
#This file is part of Detección de Hardware de Guadalinex 2005 .
#
#Detección de Hardware de Guadalinex 2005  is free software; you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation; either version 2 of the License, or
#at your option) any later version.
#
#Detección de Hardware de Guadalinex 2005  is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with Foobar; if not, write to the Free Software
#Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

import os.path

from deviceactor import DeviceActor
from utils.synaptic import Synaptic
from gettext import gettext as _

C3POICON = os.path.abspath('actors/img/ltc31.png')
C3POICONOFF = os.path.abspath('actors/img/ltc31off.png')

class Actor(DeviceActor):

    __required__ = {
      "info.bus":"usb_device",
      "usb_device.vendor_id":0x783,
      "usb_device.product_id":0x6
    }

    def on_added(self):
        s = Synaptic()
        packages = ['pcscd', 'pcsc-tools', 'libccid']

        def install_packages():
            s.install(packages)

        if s.check(packages):
            self.msg_render.show(_("C3PO"), 
                    _("Card reader detected"),
                    C3POICON)
        else:
            actions = {_("Install required packages"): install_packages}
            self.msg_render.show(_("C3PO"), _("Card reader detected"), 
                    C3POICON,
                    actions = actions)

    def on_removed(self):
        self.msg_render.show(_("C3PO"), 
                _("Card reader disconnected"),
                C3POICONOFF)