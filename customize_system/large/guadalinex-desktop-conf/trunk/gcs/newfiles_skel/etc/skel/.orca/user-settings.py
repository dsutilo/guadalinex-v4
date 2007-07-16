#!/usr/bin/python
# -*- coding: UTF-8 -*-
# user-settings.py - custom Orca settings
# Generated by orca.  DO NOT EDIT THIS FILE!!!
# If you want permanent customizations that will not
# be overwritten, edit orca-customizations.py.
#
import re
import time

import orca.debug
import orca.settings
import orca.acss

# Set the logging level to INFO if you want to log
# Orca's output of speech and braille using the
# Python logging API.  Note that setting the
# orca.debug.debugLevel to orca.debug.LEVEL_INFO
# will output the same information using Orca's
# debug facility.
#
# import logging
# orca.debug.log.setLevel(logging.INFO)

#orca.debug.debugLevel = orca.debug.LEVEL_OFF
orca.debug.debugLevel = orca.debug.LEVEL_SEVERE
#orca.debug.debugLevel = orca.debug.LEVEL_WARNING
#orca.debug.debugLevel = orca.debug.LEVEL_INFO
#orca.debug.debugLevel = orca.debug.LEVEL_CONFIGURATION
#orca.debug.debugLevel = orca.debug.LEVEL_FINE
#orca.debug.debugLevel = orca.debug.LEVEL_FINER
#orca.debug.debugLevel = orca.debug.LEVEL_FINEST
#orca.debug.debugLevel = orca.debug.LEVEL_ALL

#orca.debug.eventDebugLevel = orca.debug.LEVEL_OFF
#orca.debug.eventDebugFilter =  None
#orca.debug.eventDebugFilter = re.compile('[\S]*focus|[\S]*activ')
#orca.debug.eventDebugFilter = re.compile('nomatch')
#orca.debug.eventDebugFilter = re.compile('[\S]*:accessible-name')
#orca.debug.eventDebugFilter = re.compile('[\S]*:(?!bounds-changed)')

#orca.debug.debugFile = open(time.strftime('debug-%Y-%m-%d-%H:%M:%S.out'), 'w', 0)
#orca.debug.debugFile = open('debug.out', 'w', 0)

#orca.settings.useBonoboMain=False
#orca.settings.debugEventQueue=True
#orca.settings.gilSleepTime=0

if False:
    import sys
    import orca.debug
    sys.settrace(orca.debug.traceit)
    orca.debug.debugLevel = orca.debug.LEVEL_ALL

orca.settings.orcaModifierKeys = orca.settings.DESKTOP_MODIFIER_KEYS
orca.settings.enableSpeech = True
orca.settings.speechServerFactory = 'orca.gnomespeechfactory'
orca.settings.speechServerInfo = ['Festival GNOME Speech Driver', 'OAFIID:GNOME_Speech_SynthesisDriver_Festival:proto0.3']
orca.settings.voices = {
'default' : orca.acss.ACSS({'average-pitch': 5,
 'family': {'gender': None,
            'locale': 'spanish',
            'name': 'JuntaDeAndalucia_es_pa_diphone'},
 'gain': 9,
 'rate': 50}),
'uppercase' : orca.acss.ACSS({'average-pitch': 6}),
'hyperlink' : orca.acss.ACSS({}),
}
orca.settings.enableEchoByWord = False
orca.settings.enableKeyEcho = True
orca.settings.enablePrintableKeys = True
orca.settings.enableModifierKeys = False
orca.settings.enableLockingKeys = False
orca.settings.enableFunctionKeys = False
orca.settings.enableActionKeys = False
orca.settings.enableBraille = True
orca.settings.enableBrailleMonitor = False
orca.settings.keyboardLayout = orca.settings.GENERAL_KEYBOARD_LAYOUT_DESKTOP

try:
    __import__("orca-customizations")
except ImportError:
    pass
