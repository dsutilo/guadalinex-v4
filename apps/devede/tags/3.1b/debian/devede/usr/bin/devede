#!/usr/bin/env python
# -*- coding: UTF-8 -*-

# Copyright 2006-2007 (C) Raster Software Vigo (Sergio Costas)
# Copyright 2006-2007 (C) Peter Gill - win32 parts

# This file is part of DeVeDe
#
# DeVeDe is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# DeVeDe is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


import sys
import os
import pygtk # for testing GTK version number
pygtk.require ('2.0')
import gtk
import gtk.glade
import gobject
import subprocess
import locale
import gettext
import stat
import shutil
import pickle
import cairo

try:
	import psyco
	psyco.full()
except ImportError:
	print 'Psyco not installed, the program will just run slower'

print "DeVeDe 3.1b"

# append the directories where we install the devede's own modules
tipo=-1
try:
	fichero=open("/usr/share/devede/devede.glade","r")
	fichero.close()
	tipo=0
	found=True
except:
	found=False

if found==False:
	try:
		fichero=open("/usr/local/share/devede/devede.glade","r")
		fichero.close()
		tipo=1
		found=True
	except:
		found=False

if found==False:
	try:
		fichero=open("./devede.glade","r")
		fichero.close()
		tipo=2
		found=True
	except:
		found=False	

if tipo==0:
	#gettext.bindtextdomain('devede', '/usr/share/locale')
	#Note also before python 2.3 you need the following if
	#you need translations from non python code (glibc,libglade etc.)
	#there are other access points to this function
	#gtk.glade.bindtextdomain("devede","/usr/share/locale")
	#arbol=gtk.glade.XML("/usr/share/devede/devede.glade",domain="devede")
	# append the directories where we install the devede's own modules

	share_locale="/usr/share/locale"
	glade="/usr/share/devede/devede.glade"
	sys.path.append("/usr/lib/devede")
	font_path="/usr/share/devede"
	pic_path="/usr/share/devede"
elif tipo==1:
	# if the files aren't at /usr, try with /usr/local
	#gettext.bindtextdomain('devede', '/usr/share/locale')
	#Note also before python 2.3 you need the following if
	#you need translations from non python code (glibc,libglade etc.)
	#there are other access points to this function
	#gtk.glade.bindtextdomain("devede","/usr/share/locale")
	#arbol=gtk.glade.XML("/usr/local/share/devede/devede.glade",domain="devede")

	share_locale="/usr/share/locale" # Are you sure?
	# if the files aren't at /usr, try with /usr/local
	glade="/usr/local/share/devede/devede.glade"
	sys.path.append("/usr/local/lib/devede")
	font_path="/usr/local/share/devede"
	pic_path="/usr/local/share/devede"
elif tipo==2:
	# if the files aren't at /usr/local, try with ./
	#gettext.bindtextdomain('devede', './po/')
	#Note also before python 2.3 you need the following if
	#you need translations from non python code (glibc,libglade etc.)
	#there are other access points to this function
	#gtk.glade.bindtextdomain("devede","/usr/share/locale")
	#arbol=gtk.glade.XML("./devede.glade",domain="devede")
	
	# if the files aren't at /usr/local, try with ./
	share_locale="./po/"
	glade="./devede.glade"
	sys.path.append(os.getcwd())#("./")
	font_path=os.getcwd()#"./"
	pic_path=os.path.join(font_path, "pixmaps") #pic_path=font_path
else:
	print "Can't locate extra files. Aborting."
	sys.exit(1)


#####################
#   GetText Stuff   #
#####################

gettext.bindtextdomain('devede',share_locale)
locale.setlocale(locale.LC_ALL,"")
gettext.textdomain('devede')
gettext.install("devede",localedir=share_locale) # None is sys default locale
#   Note also before python 2.3 you need the following if
#   you need translations from non python code (glibc,libglade etc.)
#   there are other access points to this function
gtk.glade.bindtextdomain("devede",share_locale)
arbol=gtk.glade.XML(glade,domain="devede")
#   To actually call the gettext translation functions
#   just replace your strings "string" with gettext("string")
#   The following shortcut are usually used:
_ = gettext.gettext

try:
	from devede_other import *
except:
	print "Failed to load modules 2. Exiting"
	sys.exit(1)
try:
	from devede_gtk_helper import *
except:
	print "Failed to load modules 3. Exiting"
	sys.exit(1)
try:
	import devede_convert
except:
	print "Failed to load modules. Exiting"
	sys.exit(1)

import devede_xml_menu

###################################################
# This block contains all the Drag&Drop functions #
###################################################


def draganddrop_two(widget,drag_context, x, y, selection, info, time,arbol):

	""" Manages the Drag&Drop in the property window """

	lista=separa_dnd(selection.data)

	if len(lista)==0:
		return

	if len(lista)>1:
		show_error2(_("Please, add only one file each time."),arbol)
		return

	w=arbol.get_widget("moviefile")
	w.set_filename(lista[0])


def draganddrop(widget,drag_context, x, y, selection, info, time,arbol,structure,global_vars):
	
	""" Manages the Drag&Drop in the main window """
	
	lista=separa_dnd(selection.data)
	fine=True
	lista2=[]
	for elemento in lista:
		done,audio=set_values_of_file(arbol,global_vars,elemento,True) # check if files are videos
		print done
		print audio
		if (done==False):
			fine=False
			break
		
		lista2.append(global_vars["current_file"])
	
	if fine:
		titulo,capitulo=get_marked(arbol,global_vars)
		elemento=structure[titulo]
		for elemento2 in lista2:
			elemento.append(elemento2)
		refresh_chapters(arbol,structure,global_vars)
		set_buttons(arbol,structure,global_vars)
				
	else:
		show_error2(_("Some files weren't video files.\nNone added."),arbol)


######################################################################
# This block contains the callbacks and other functions for the      #
# Properties window (the one where you choose the bitrate and so on  #
######################################################################

def clear_subtitles(widget,arbol):
	w=arbol.get_widget("subtitles_chooser")
	w.unselect_all()


def set_resolution(palvalue,arbol):

	""" Sets the labels with the rigth resolution values, depending
	if the user selected PAL/SECAM or NTSC """

	if palvalue:
		res1="288"
		res2="576"
	else:
		res1="240"
		res2="480"

	w=arbol.get_widget("res720x480")
	w.set_label("720x"+res2)
	w=arbol.get_widget("res704x480")
	w.set_label("704x"+res2)
	w=arbol.get_widget("res480x480")
	w.set_label("480x"+res2)
	w=arbol.get_widget("res352x480")
	w.set_label("352x"+res2)
	w=arbol.get_widget("res352x240")
	w.set_label("352x"+res1)
	
	
def add_a_file(args,arbol,structure,global_vars):

	""" Callback for the "Add file" button """

	wfile=arbol.get_widget("wfile")
	
	set_file_values(arbol,global_vars)
	
	titulo,capitulo=get_marked(arbol,global_vars)
	
	if len(global_vars["chapter_to_modify"])==0:
		for elemento in structure:
			if elemento[0]==structure[titulo][0]:
				elemento.append(global_vars["current_file"])
				break
	else:
		for elemento in global_vars["current_file"]:
			global_vars["chapter_to_modify"][elemento]=global_vars["current_file"][elemento]
	
	save_config(global_vars)
	
	wfile.hide()
	refresh_chapters(arbol,structure,global_vars)
	set_buttons(arbol,structure,global_vars)


def set_file_values(arbol,global_vars):

	""" Fills the structure GLOBAL_VARS[NEW_CHAPTER] with the values selected by the user """

	w=arbol.get_widget("subtitles_chooser")
	subt=w.get_filename()
	if (subt==None) or (subt==""):
		global_vars["current_file"]["subtitles"]=""
	else:
		global_vars["current_file"]["subtitles"]=subt

	w=arbol.get_widget("blackbars")
	if w.get_active():
		global_vars["current_file"]["blackbars"]=0
	else:
		global_vars["current_file"]["blackbars"]=1
	
	w=arbol.get_widget("trell")
	global_vars["current_file"]["trellis"]=w.get_active()
	
	global_vars["current_file"]["mbd"]=0
	w=arbol.get_widget("mbd1")
	if w.get_active():
		global_vars["current_file"]["mbd"]=1
	w=arbol.get_widget("mbd2")
	if w.get_active():
		global_vars["current_file"]["mbd"]=2
		
	global_vars["current_file"]["deinterlace"]="none"
	w=arbol.get_widget("deinterlace_lb")
	if w.get_active():
		global_vars["current_file"]["deinterlace"]="lb"
	w=arbol.get_widget("deinterlace_md")
	if w.get_active():
		global_vars["current_file"]["deinterlace"]="md"
	w=arbol.get_widget("deinterlace_fd")
	if w.get_active():
		global_vars["current_file"]["deinterlace"]="fd"
		
	w=arbol.get_widget("ismpeg")
	global_vars["current_file"]["ismpeg"]=w.get_active()
	
	w=arbol.get_widget("do_chapters")
	if w.get_active():
		w=arbol.get_widget("chapter_long")
		global_vars["current_file"]["lchapters"]=w.get_value()
	else:
		global_vars["current_file"]["lchapters"]=0
	
	w=arbol.get_widget("audiodelay")
	global_vars["current_file"]["adelay"]=float(w.get_value())
		
	w=arbol.get_widget("video_rate")
	global_vars["current_file"]["vrate"]=int(w.get_value())
	w=arbol.get_widget("audio_rate")
	global_vars["current_file"]["arate"]=int(w.get_value())
	
	w=arbol.get_widget("full_length")
	if w.get_active():
		global_vars["current_file"]["cutting"]=0
	else:
		w=arbol.get_widget("first_half")
		if w.get_active():
			global_vars["current_file"]["cutting"]=1
		else:
			global_vars["current_file"]["cutting"]=2

	w=arbol.get_widget("video_pal")
	if w.get_active():
		global_vars["current_file"]["fps"]=25
		pal=True
	else:
		global_vars["current_file"]["fps"]=30
		pal=False

	w=arbol.get_widget("aspect_ratio")
	
	if (global_vars["disctocreate"]=="dvd") or (global_vars["disctocreate"]=="divx"):
		if w.get_active():
			global_vars["current_file"]["aspect"]=1.77777777
		else:
			global_vars["current_file"]["aspect"]=1.33333333
	else:
		global_vars["current_file"]["aspect"]=1.33333333

	w=arbol.get_widget("sub_codepage")
	global_vars["current_file"]["sub_codepage"]=w.child.get_text()
	w=arbol.get_widget("sub_up")
	global_vars["current_file"]["subtitles_up"]=w.get_active()

	retorno,resx,resy=get_resolution_from_buttons(arbol,pal)
	global_vars["current_file"]["resolution"]=retorno
	
	w=arbol.get_widget("custom_params")
	global_vars["current_file"]["params"]=w.get_text()


def refresh_film_data(arbol,global_vars):

	""" Repaints all the data about the current film, recalculating
	the size needed and other params """

	if len(global_vars["current_file"])==0:
		empty=True
	else:
		empty=False
	
	w=arbol.get_widget("video_pal")
	set_resolution(w.get_active(),arbol)
	
	w=arbol.get_widget("o_size2")
	if empty:
		w.set_text("")
	else:
		w.set_text(str(global_vars["current_file"]["owidth"])+"x"+str(global_vars["current_file"]["oheight"]))
	w=arbol.get_widget("leng2")
	if empty:
		w.set_text("")
	else:
		w.set_text(str(global_vars["current_file"]["olength"]))
	w=arbol.get_widget("fps")
	if empty:
		w.set_text("")
	else:
		w.set_text(str(global_vars["current_file"]["ofps"]))
	w=arbol.get_widget("vrate2")
	if empty:
		w.set_text("")
	else:
		w.set_text(str(global_vars["current_file"]["ovrate"]))
	w=arbol.get_widget("arate2")
	if empty:
		w.set_text("")
	else:
		w.set_text(str(global_vars["current_file"]["oarate"]))
	
	w=arbol.get_widget("video_rate")
	vrate=w.get_value()
	w=arbol.get_widget("audio_rate")
	arate=w.get_value()
	
	w=arbol.get_widget("full_length")
	if w.get_active():
		divide=False
	else:
		divide=True
		
	w=arbol.get_widget("eleng2")
	if empty:
		w.set_text("")
	else:
		w2=arbol.get_widget("ismpeg")
		if w2.get_active():
			l=int(global_vars["current_file"]["filesize"]/1000000)
		else:
			l=int(((vrate+arate)*global_vars["current_file"]["olength"])/8000)
			if divide:
				l/=2
		w.set_text(str(l))
		
	w=arbol.get_widget("f_size2")
	if empty:
		w.set_text("")
	else:
		w.set_text(str(global_vars["current_file"]["width"])+"x"+str(global_vars["current_file"]["height"]))


def get_resolution_from_buttons(arbol,pal):

	""" Returns the resolution choosed by the user """

	retorno=0
	resx=0
	resy=0

	if pal:
		h1=576
		h2=288
	else:
		h1=480
		h2=240

	w=arbol.get_widget("res720x480")
	if w.get_active():
		retorno=1
		resx=720
		resy=h1
	
	w=arbol.get_widget("res704x480")
	if w.get_active():
		retorno=2
		resx=704
		resy=h1
		
	w=arbol.get_widget("res480x480")
	if w.get_active():
		retorno=3
		resx=480
		resy=h1
		
	w=arbol.get_widget("res352x480")
	if w.get_active():
		retorno=4
		resx=352
		resy=h1
		
	w=arbol.get_widget("res352x240")
	if w.get_active():
		retorno=5
		resx=352
		resy=h2
		
	return retorno,resx,resy


def get_recomended_resolution(arbol,global_vars,pal,blind):

	""" Returns the recomended resolution for a video based in its original
	resolution and the resolution chosed by the user """

	if blind:
		retorno=0 # if BLIND is TRUE, we must use the default resolution
	else:
		retorno,resx,resy=get_resolution_from_buttons(arbol,pal)
	
	if pal:
		nheigh1=576
		nheigh2=288
	else:
		nheigh1=480
		nheigh2=240

	if retorno==0: # default resolution; we have to take the most similar resolution
		if global_vars["disctocreate"]=="vcd":
			resx=352
			resy=nheigh2
		elif global_vars["disctocreate"]=="cvd":
			resx=352
			resy=nheigh1
		elif global_vars["disctocreate"]=="svcd":
			resx=480
			resy=nheigh1
		else: # dvd o divx
			if (global_vars["current_file"]["owidth"]<=352):
				resx=352
				if (global_vars["current_file"]["oheight"]<=nheigh2):
					resy=nheigh2
				else:
					resy=nheigh1
			else:
				resx=720
				resy=nheigh1
	
	return retorno,resx,resy


def set_final_size(arbol,global_vars,blind=False):

	""" Sets the final size and recomended videorate in base of the original video size.
	If BLIND is True, it will not update the file window (because we
	are adding the file using Drag&Drop into the main window) """

	if blind:
		pal2=global_vars["PAL"]
	else:
		w=arbol.get_widget("video_pal")
		pal2=w.get_active()
	
	if pal2:
		global_vars["PAL"]=True
		nheigh1=576
		nheigh2=288
	else:
		global_vars["PAL"]=False
		nheigh1=480
		nheigh2=240
		
	if len(global_vars["current_file"])==0:
		return
	
	retorno,resx,resy=get_recomended_resolution(arbol,global_vars,pal2,blind)

	global_vars["current_file"]["resolution"]=retorno
	global_vars["current_file"]["width"]=resx
	global_vars["current_file"]["height"]=resy

	if global_vars["PAL"]:
		global_vars["current_file"]["fps"]=25
	else:
		global_vars["current_file"]["fps"]=30

	w=arbol.get_widget("video_rate")
	valor=w.get_value()
	
	if (blind) or (global_vars["disctocreate"]=="vcd"):
		change_datarate=False
	else:
		if (valor==5001) or (valor==3001) or (valor==2001):
			# change the data rate only if the user stil hasn't changed it
			change_datarate=True
		else:
			change_datarate=False
	
	if global_vars["disctocreate"]=="vcd":
		global_vars["current_file"]["vrate"]=1152
		global_vars["current_file"]["arate"]=224
		return
	elif global_vars["disctocreate"]=="cvd":
		if blind or change_datarate:
			global_vars["current_file"]["vrate"]=2001
		if blind:
			global_vars["current_file"]["arate"]=224
		if change_datarate:
			w.set_value(2001)
		return
	elif global_vars["disctocreate"]=="svcd":
		if blind or change_datarate:
			global_vars["current_file"]["vrate"]=2001
		if blind:
			global_vars["current_file"]["arate"]=224
		if change_datarate:
			w.set_value(2001)
		return
	
	# DVD o DIVX

	if (global_vars["current_file"]["width"]<=480):
		if (global_vars["current_file"]["height"]<=nheigh2):
			if change_datarate:
				w.set_value(2001)
			if blind or change_datarate:
				global_vars["current_file"]["vrate"]=2001
			if blind:
				global_vars["current_file"]["arate"]=224
		else:
			if change_datarate:
				w.set_value(3001)
			if blind or change_datarate:
				global_vars["current_file"]["vrate"]=3001
			if blind:
				global_vars["current_file"]["arate"]=224
	else:
		if change_datarate:
			w.set_value(5001)
		if blind or change_datarate:
			global_vars["current_file"]["vrate"]=5001
		if blind:
			global_vars["current_file"]["arate"]=224


def set_values_of_file(arbol,global_vars,filename,blind=False):

	""" Reads the values of the video (width, heigth, fps...) and stores them
	into GLOBAL_VARS[current_file] """
	handler=''

	vrate=0
	arate=0
	width=0
	heigh=0
	fps=0
	length=0
	audio=0
	video=0
	audiorate=0
	aspect_ratio=1.3333333333

	# first check with 0 frames to ensure it isn't an audio file


	if not sys.platform=='win32':
		handler=subprocess.Popen('mplayer -identify -ao null -vo null -frames 0 "'+filename+'" 2>/dev/null |grep ID',shell=True,bufsize=32768,stdout=subprocess.PIPE)
	else:		
		zz=["mplayer.exe", "-identify", "-ao", "null", "-vo", "null", "-frames", "0", filename]
		handler=launch_program(zz)

	while True:
		linea=handler.stdout.readline()
		print linea
		if linea=="":
			break
		if linea[:14]=="ID_VIDEO_WIDTH":
			width=int(linea[15:])
		if linea[:15]=="ID_VIDEO_HEIGHT":
			heigh=int(linea[16:])
		if linea[:11]=="ID_VIDEO_ID":
			video+=1
		if linea[:11]=="ID_AUDIO_ID":
			audio+=1
	handler.wait()
	
	if (video==0) or (width==0) or (heigh==0):
		return False,audio

	# now we check all parameters, but with one frame to ensure that we get the aspect ratio
	#TODO

	vrate=0
	arate=0
	width=0
	heigh=0
	fps=0
	length=0
	audio=0
	video=0
	audiorate=0
	aspect_ratio=1.3333333333
	
	if not sys.platform == 'win32':
		handler=subprocess.Popen('mplayer -identify -ao null -vo null -frames 1 "'+filename+'" 2>/dev/null |grep ID',shell=True,bufsize=32768,stdout=subprocess.PIPE)
	else:
		zz=["mplayer.exe", "-identify", "-ao", "null", "-vo", "null", "-frames", "1", filename]
		handler=launch_program(zz)


	while True:
		linea=handler.stdout.readline()
		if linea=="":
			break
		if linea[:16]=="ID_VIDEO_BITRATE":
			vrate=int(linea[17:])
		if linea[:14]=="ID_VIDEO_WIDTH":
			width=int(linea[15:])
		if linea[:15]=="ID_VIDEO_HEIGHT":
			heigh=int(linea[16:])
		if linea[:15]=="ID_VIDEO_ASPECT":
			aspect_ratio=float(linea[16:])
		if linea[:12]=="ID_VIDEO_FPS":
			fps2=linea[13:]
			if ord(fps2[-1])<32:
				fps2=fps2[:-1]
			posic=linea.find(".")
			if posic==-1:
				fps=int(linea[13:])
			else:
				fps=int(linea[13:posic])
				if linea[posic+1]=="9":
					fps+=1
		if linea[:16]=="ID_AUDIO_BITRATE":
			arate=int(linea[17:])
			
		if linea[:13]=="ID_AUDIO_RATE":
			audiorate=int(linea[14:])
			
		if linea[:9]=="ID_LENGTH":
			length=int(float(linea[10:]))
		if linea[:11]=="ID_VIDEO_ID":
			video+=1
		if linea[:11]=="ID_AUDIO_ID":
			audio+=1
	handler.wait()
	

	while filename[-1]==os.sep:
		filename=filename[:-1]
	
	nombre=filename
	while True: # get the filename without the path
		posic=nombre.find("/")
		if posic==-1:
			break
		else:
			nombre=nombre[posic+1:]
	
	# filename[0]; path[1]; width[2]; heigh[3]; length[4] (seconds); original fps[5];
	# original videorate["oarate"]; original audiorate[7];
	# final videorate[8]; final arate[9]; final width[10]; final heigh[11];
	# 0=Black bars, 1=Scale picture [12];
	# length of chapters[13]; audio delay["fps"]; final fps["arateunc"]; original audio rate (uncompressed)["oaspect"];
	# original aspect ratio[17]; final aspect ratio[18];
	# 0=full length, 1=first half, 2=second half [19];
	# Resolution: 0=auto, 1=720x480, 2=704x480, 3=480x480, 4=352x480, 5=352x240 [20]
	# extra parameters [21]

	global_vars["current_file"]={}
	global_vars["current_file"]["filename"]=nombre
	global_vars["current_file"]["path"]=filename
	global_vars["current_file"]["owidth"]=width
	global_vars["current_file"]["oheight"]=heigh
	global_vars["current_file"]["olength"]=length
	global_vars["current_file"]["ofps"]=fps
	global_vars["current_file"]["ofps2"]=fps2
	global_vars["current_file"]["ovrate"]=vrate/1000
	global_vars["current_file"]["oarate"]=arate/1000
	global_vars["current_file"]["blackbars"]=0 # black bars, no scale
	global_vars["current_file"]["lchapters"]=5
	global_vars["current_file"]["adelay"]=0
	global_vars["current_file"]["arateunc"]=audiorate
	global_vars["current_file"]["oaspect"]=aspect_ratio

	global_vars["current_file"]["cutting"]=0 # full length
	global_vars["current_file"]["resolution"]=0 # auto
	global_vars["current_file"]["params"]=""
	global_vars["current_file"]["ismpeg"]=False
	global_vars["current_file"]["filesize"]=os.stat(filename)[stat.ST_SIZE]
	global_vars["current_file"]["trellis"]=True
	global_vars["current_file"]["mbd"]=2
	global_vars["current_file"]["deinterlace"]="none"
	global_vars["current_file"]["subtitles"]=""
	global_vars["current_file"]["sub_codepage"]="ISO-8859-1"
	global_vars["current_file"]["subtitles_up"]=False

	set_final_size(arbol,global_vars,blind)
	
	print "Aspect ratio: "+str(aspect_ratio)
	if (global_vars["disctocreate"]=="dvd") or (global_vars["disctocreate"]=="divx"):
		if blind==False:
			w=arbol.get_widget("aspect_ratio")
			w.set_sensitive(True)
		if (aspect_ratio>=1.7777777) and ((global_vars["current_file"]["width"]==720) or (global_vars["disctocreate"]=="divx")):
			w=arbol.get_widget("aspect_ratio")
			global_vars["current_file"]["aspect"]=1.77777777
			if (blind==False) and (global_vars["doing_modify"]==False):
				w.set_active(True)
		else:
			global_vars["current_file"]["aspect"]=1.33333333
			if (blind==False) and (global_vars["doing_modify"]==False):
				w=arbol.get_widget("aspect_ratio")
				w.set_active(False)
	else:
		if (blind==False):
			w=arbol.get_widget("aspect_ratio")
			w.set_active(False)
			w.set_sensitive(False)
		global_vars["current_file"]["aspect"]=1.33333333
	global_vars["doing_modify"]=False
	
	return True,0
	

def filechanged(args,arbol,global_vars):

	""" This callback is called every time the file name of the movie
	is changed (even when is set by the "Modify chapter" button's callback) """

	filechoser=arbol.get_widget("moviefile")
	fileaccept=arbol.get_widget("fileaccept")
	preview_film2=arbol.get_widget("preview_film")
		
	filename=filechoser.get_filename()
	if (filename==None) or (filename==""):
		fileaccept.set_sensitive(False)
		preview_film2.set_sensitive(False)
		return


	done,audio=set_values_of_file(arbol,global_vars,filename)
	
	if done:
		refresh_film_data(arbol,global_vars)
		refresh_screen()
		fileaccept.set_sensitive(True)
		preview_film2.set_sensitive(True)
	else:
		if audio==0:
			show_error(_("File doesn't seem to be a video file."),arbol)
		else:
			show_error(_("File seems to be an audio file."),arbol)
		global_vars["current_file"]={}
		fileaccept.set_sensitive(False)
		preview_film2.set_sensitive(False)
	set_film_buttons(arbol,global_vars)



#######################################################
# This block contains all the callbacks and functions #
# for the main window                                 #
#######################################################


def create_dvd(widget,arbol,structure,global_vars):
	
	global conversor
	
	actions=0	
	w=arbol.get_widget("only_convert")
	if w.get_active():
		actions=1
	else:
		w=arbol.get_widget("create_dvd")
		if (w.get_active()) or ((global_vars["disctocreate"]!="dvd") and (global_vars["disctocreate"]!="divx")):
			actions=2
		else:
			actions=3

	global_vars["number_actions"]=actions
	w=arbol.get_widget("erase_files")
	global_vars["erase_temporary_files"]=w.get_active()

	conversor=devede_convert.create_all(structure,global_vars)
	if conversor.create_disc():
		w=arbol.get_widget("wmain")
		w.hide()


def get_marked(arbol,global_vars):

	""" Returns the title and chapter currently marked in the main window """

	ltitles=arbol.get_widget("ltitles")
	lchapters=arbol.get_widget("lchapters")

	try:
		tree,iter=ltitles.get_selection().get_selected()
		titulo=tree.get_value(iter,0)
	except TypeError:
		titulo=-1
		
	try:
		tree,iter=lchapters.get_selection().get_selected()
		capitulo=1+tree.get_value(iter,0) # zero is the Title value
	except TypeError:
		capitulo=-1
	
	global_vars["currenttitleselected"]=titulo
	global_vars["currentfileselected"]=capitulo
	
	return titulo,capitulo


def set_buttons(arbol,structure,global_vars):

	""" Enables or disables the button to create a DVD, and the
	buttons to move up or down a title or chapter """

	titulo,capitulo=get_marked(arbol,global_vars)
		
	if titulo==-1:
		title_marked=False
	else:
		title_marked=True

	title_up=arbol.get_widget("titleup")
	if titulo==0:
		title_up.set_sensitive(False)
	else:
		title_up.set_sensitive(True)
	
	title_down=arbol.get_widget("titledown")
	if titulo+1==len(structure):
		title_down.set_sensitive(False)
	else:
		title_down.set_sensitive(True)

	if capitulo==-1:
		chapter_marked=False
	else:
		chapter_marked=True

	files_up=arbol.get_widget("filesup")
	if capitulo<2:
		files_up.set_sensitive(False)
	else:
		files_up.set_sensitive(True)
	
	files_down=arbol.get_widget("filesdown")
	if (capitulo==-1) or (capitulo+1==len(structure[titulo])):
		files_down.set_sensitive(False)
	else:
		files_down.set_sensitive(True)

	del_title=arbol.get_widget("del_title")
	if len(structure)>1:
		del_title.set_sensitive(title_marked)	
	else:
		del_title.set_sensitive(False)
	
	add_title=arbol.get_widget("add_title")
	if (len(structure)<12):
		add_title.set_sensitive(True)
	else:
		add_title.set_sensitive(False)
	
	add_chapter=arbol.get_widget("add_chapter")
	add_chapter.set_sensitive(title_marked)
	
	del_chapter=arbol.get_widget("del_chapter")
	del_chapter.set_sensitive(chapter_marked)
	
	prop_chapter=arbol.get_widget("prop_chapter")
	prop_chapter.set_sensitive(chapter_marked)
	
	valor=False
	for elemento in structure:
		if len(elemento)>1:
			valor=True
			break

	main_go=arbol.get_widget("main_go")
	main_go.set_sensitive(valor)
	set_video_values(arbol,structure,global_vars)
	
	
def dvd_changed(args,arbol,structure,global_vars):

	""" This function is called when the user changes the media size """

	set_video_values(arbol,structure,global_vars)
	
	
def set_video_values(arbol,structure,global_vars):

	""" Sets the video values in the main window when the user clicks
	a chapter """

	titulo,capitulo=get_marked(arbol,global_vars)

	if (capitulo!=-1) and (titulo!=-1):
		encontrado2=structure[titulo]
		encontrado=encontrado2[capitulo]
		w=arbol.get_widget("oaspect")
		if (encontrado["aspect"])>1.5:
			w.set_text("16:9")
		else:
			w.set_text("4:3")
		w=arbol.get_widget("o_size")
		w.set_text(str(encontrado["owidth"])+"x"+str(encontrado["oheight"]))
		w=arbol.get_widget("leng")
		w.set_text(str(encontrado["olength"]))
		w=arbol.get_widget("vrate")
		w.set_text(str(encontrado["vrate"]))
		w=arbol.get_widget("arate")
		w.set_text(str(encontrado["arate"]))
		w=arbol.get_widget("eleng")
		l=int(((encontrado["vrate"]+encontrado["arate"])*encontrado["olength"])/8000)
		w.set_text(str(l))#+(l/50))) # add a 2% for failsafe
		w=arbol.get_widget("achap")
		if encontrado["lchapters"]==0:
			w.set_text(_("no chapters"))
		else:
			w.set_text(str(int(encontrado["lchapters"])))
		w=arbol.get_widget("video_format")
		if encontrado["fps"]==25:
			w.set_text("25 (PAL)")
		elif encontrado["fps"]==30:
			if (encontrado["ofps"]==24) and ((global_vars["disctocreate"]=="dvd") or (global_vars["disctocreate"]=="divx")):
				w.set_text("24 (NTSC)")
			else:
				w.set_text("30 (NTSC)")
		else:
			w.set_text(str(int(encontrado["fps"])))
		
		w=arbol.get_widget("fsizem")
		w.set_text(str(encontrado["width"])+"x"+str(encontrado["height"]))
	else:
		w=arbol.get_widget("oaspect")
		w.set_text("")
		w=arbol.get_widget("o_size")
		w.set_text("")
		w=arbol.get_widget("leng")
		w.set_text("")
		w=arbol.get_widget("vrate")
		w.set_text("")
		w=arbol.get_widget("arate")
		w.set_text("")
		w=arbol.get_widget("eleng")
		w.set_text("")
		w=arbol.get_widget("achap")
		w.set_text("")
		w=arbol.get_widget("video_format")
		w.set_text("")
		w=arbol.get_widget("fsizem")
		w.set_text("")
		
	total=calcula_tamano_total(structure)
	total/=1000
	
	w=arbol.get_widget("dvdsize")
	activo=w.get_active()
	
	# here we choose the size in Mbytes for the media
	if 0==activo:
		tamano=180.0
	elif 1==activo:
		tamano=710.0
	elif 2==activo:
		tamano=790.0
	elif 3==activo:
		tamano=1200.0
	elif 4==activo:
		tamano=4500.0
	else:
		tamano=7600.0

	w=arbol.get_widget("usage")
	if total>tamano:
		w.set_fraction(1.0)
		addv=1
	else:
		w.set_fraction(total/tamano)
		addv=0
	w.set_text(str(addv+int((total/tamano)*100))+"%")


def titleup(args,arbol,structure,global_vars):

	""" Moves a title up in the list """

	titulo,capitulo=get_marked(arbol,global_vars)
	
	tempo=structure[titulo-1]
	structure[titulo-1]=structure[titulo]
	structure[titulo]=tempo
	global_vars["currenttitleselected"]-=1
	refresh_titles(arbol,structure,global_vars)
	refresh_chapters(arbol,structure,global_vars)
	set_buttons(arbol,structure,global_vars)


def titledown(args,arbol,structure,global_vars):

	""" Moves a title down in the list """

	titulo,capitulo=get_marked(arbol,global_vars)
	
	tempo=structure[titulo+1]
	structure[titulo+1]=structure[titulo]
	structure[titulo]=tempo
	global_vars["currenttitleselected"]+=1
	refresh_titles(arbol,structure,global_vars)
	refresh_chapters(arbol,structure,global_vars)
	set_buttons(arbol,structure,global_vars)


def filesup(args,arbol,structure,global_vars):

	""" Moves a chapter up in the list """

	titulo,capitulo=get_marked(arbol,global_vars)

	tempo=structure[titulo][capitulo-1]
	structure[titulo][capitulo-1]=structure[titulo][capitulo]
	structure[titulo][capitulo]=tempo
	global_vars["currentfileselected"]-=1
	refresh_chapters(arbol,structure,global_vars)
	set_buttons(arbol,structure,global_vars)


def filesdown(args,arbol,structure,global_vars):

	""" Moves a chapter down in the list """

	titulo,capitulo=get_marked(arbol,global_vars)
	
	tempo=structure[titulo][capitulo+1]
	structure[titulo][capitulo+1]=structure[titulo][capitulo]
	structure[titulo][capitulo]=tempo
	global_vars["currentfileselected"]+=1
	refresh_chapters(arbol,structure,global_vars)
	set_buttons(arbol,structure,global_vars)


def show_about(args,arbol):

	""" Shows the About dialog """
	
	wabout=arbol.get_widget("aboutdialog1")
	wabout.show()
	wabout.run()
	wabout.hide()


def refresh_titles(arbol,structure,global_vars):

	""" Refreshes the title list """

	global_vars["currentfileselected"]=-1
	
	global_vars["list_titles"].clear()
	global_vars["list_chapters"].clear()
		
	contador=-1
	for elemento in structure:
		contador+=1
		entrada=global_vars["list_titles"].insert_before(None,None)
		global_vars["list_titles"].set_value(entrada,1,elemento[0]["nombre"])
		global_vars["list_titles"].set_value(entrada,0,contador)
	
	if contador<global_vars["currenttitleselected"]:
		global_vars["currenttitleselected"]=contador
	
	if global_vars["currenttitleselected"]<0:
		global_vars["currenttitleselected"]=0

	ltitles=arbol.get_widget("ltitles")
	ltitles.get_selection().select_path( (global_vars["currenttitleselected"],))


def refresh_chapters(arbol,structure,global_vars):

	""" Refreshes the chapter list """

	fichero=global_vars["currentfileselected"]
	titulo,fichero2=get_marked(arbol,global_vars)
	
	if (titulo==-1):
		return
	
	if (global_vars["currentfileselected"]==-1):
		global_vars["currentfileselected"]=1
	else:
		global_vars["currentfileselected"]=fichero
	
	global_vars["list_chapters"].clear()
	
	lista=structure[titulo]

	if len(lista)<=1:
		return
		
	contador=0
	for elemento in lista[1:]:
		entrada=global_vars["list_chapters"].insert_before(None,None)
		global_vars["list_chapters"].set_value(entrada,1,elemento["filename"])
		global_vars["list_chapters"].set_value(entrada,0,contador)
		contador+=1
	
	if contador<global_vars["currentfileselected"]:
		global_vars["currentfileselected"]=contador
	
	lchapters=arbol.get_widget("lchapters")
	lchapters.get_selection().select_path( (global_vars["currentfileselected"]-1,))


def wmain_delete(args,more,arbol):

	""" Delete callback for main window, where it shows the "Are you sure?" window """

	wcancel=arbol.get_widget("wcancel")
	wcancel.show()
	
	return True


def wmain_delete2(args,arbol):

	""" Callback for Cancel button (in main window), where it shows the "Are you sure?" window """

	wcancel=arbol.get_widget("wcancel")
	wcancel.show()


def titleclick(args,more,arbol,structure,global_vars):

	""" Callback for click event in the title list. It refreshes the chapters
	and sets the buttons and film info """

	refresh_chapters(arbol,structure,global_vars)
	set_buttons(arbol,structure,global_vars)


def chapterclick(args,more,arbol,structure,global_vars):

	""" Callback for click event in the chapter list. It
	sets the buttons and film info """

	set_buttons(arbol,structure,global_vars)


def addtitle(args,arbol,structure,global_vars):

	""" Callback for "Add title" button. It adds a new title and
	refreshes the list of titles """

	nombre=_("Title")
	variable={}
	variable["nombre"]=(nombre)+" "+str(global_vars["titlecounter"])
	variable["jumpto"]="menu" # can be MENU, FIRST, NEXT, LAST or LOOP
	structure.append([variable])
	global_vars["titlecounter"]+=1
	global_vars["currenttitleselected"]=10000 # to ensure that we select the newly created
	refresh_titles(arbol,structure,global_vars)
	set_buttons(arbol,structure,global_vars)


def deltitle(args,arbol,structure,global_vars):

	""" Callback for "Delete title" button. It asks the user if
	is sure """

	titulo,capitulo=get_marked(arbol,global_vars)

	etiqueta=arbol.get_widget("what_title")
	etiqueta.set_text(structure[titulo][0]["nombre"])
	
	wdel_title=arbol.get_widget("wdel_title")
	wdel_title.show()


def addchapter(args,arbol,global_vars):

	""" Callback for the "Add chapter" button """

	wfile=arbol.get_widget("wfile")

	global_vars["chapter_to_modify"]={}
	global_vars["current_file"]={}

	value_changed("",arbol,global_vars) # clear the values

	w=arbol.get_widget("moviefile")
	w.unselect_all()
	w=arbol.get_widget("subtitles_chooser")
	w.unselect_all()
	w=arbol.get_widget("sub_codepage")
	w.child.set_text("ISO-8859-1")
	w=arbol.get_widget("sub_up")
	w.set_active(False)
	w=arbol.get_widget("fileaccept")
	w.set_sensitive(False)
	w=arbol.get_widget("preview_film")
	w.set_sensitive(False)
	
	w=arbol.get_widget("trell")
	w.set_active(True)
	
	w=arbol.get_widget("mbd2")
	w.set_active(True)
	
	w=arbol.get_widget("deinterlace")
	w.set_active(True)
	
	w=arbol.get_widget("video_rate")
	if global_vars["disctocreate"]=="vcd":
		w.set_value(1152)
	elif (global_vars["disctocreate"]=="svcd") or (global_vars["disctocreate"]=="cvd"):
		w.set_value(2001)
		w.set_range(600,2160)
	else:
		w.set_value(5001)
	
	w=arbol.get_widget("aspect_ratio")
	if (global_vars["disctocreate"]=="dvd") or (global_vars["disctocreate"]=="divx"):
		w.set_sensitive(True)
	else:
		w.set_sensitive(False)
	
	w=arbol.get_widget("audio_rate")
	w.set_value(224)
	if (global_vars["disctocreate"]=="svcd") or (global_vars["disctocreate"]=="cvd"):
		w.set_range(64,384)
	
	w=arbol.get_widget("ismpeg")
	w.set_active(False)
	
	set_film_buttons(arbol,global_vars)
	
	w=arbol.get_widget("do_chapters")
	w.set_active(True)
	w=arbol.get_widget("chapter_long")
	w.set_value(5)
	w=arbol.get_widget("audiodelay")
	w.set_value(0.0)
	w=arbol.get_widget("blackbars")
	w.set_active(True)
	w=arbol.get_widget("full_length")
	w.set_active(True)
	
	if global_vars["PAL"]:
		w=arbol.get_widget("video_pal")
	else:
		w=arbol.get_widget("video_ntsc")
	w.set_active(True)
	
	w=arbol.get_widget("resauto")
	w.set_active(True)
	w=arbol.get_widget("custom_params")
	w.set_text("")
	w=arbol.get_widget("the_notebook")
	w.set_current_page(0)
	
	wfile.show()
	
	
def delete_chapter(args,arbol,structure,global_vars):

	""" Callback for the "Delete chapter" button """

	titulo,capitulo=get_marked(arbol,global_vars)
	label=arbol.get_widget("labelchapter")
	label.set_text(structure[titulo][capitulo]["filename"])
	
	wdel_chapter=arbol.get_widget("wdel_chapter")
	wdel_chapter.show()


def modify_chapter(args,arbol,structure,global_vars):

	""" Callback for the "Modify chapter" button """

	wfile=arbol.get_widget("wfile")
	
	titulo,capitulo=get_marked(arbol,global_vars)
	
	if (titulo==-1) or (capitulo==-1):
		return

	global_vars["chapter_to_modify"]=structure[titulo][capitulo]
	
	if global_vars["chapter_to_modify"]["resolution"]==0: # auto resolution
		w=arbol.get_widget("resauto")
	elif global_vars["chapter_to_modify"]["resolution"]==1: # 720x480
		w=arbol.get_widget("res720x480")
	elif global_vars["chapter_to_modify"]["resolution"]==2: # 704x480
		w=arbol.get_widget("res704x480")
	elif global_vars["chapter_to_modify"]["resolution"]==3: # 480x480
		w=arbol.get_widget("res480x480")
	elif global_vars["chapter_to_modify"]["resolution"]==4: # 352x480
		w=arbol.get_widget("res352x480")
	else:
		w=arbol.get_widget("res352x240")
	
	w.set_active(True)
	
	w=arbol.get_widget("trell")
	w.set_active(global_vars["chapter_to_modify"]["trellis"])
	
	if global_vars["chapter_to_modify"]["mbd"]==0:
		w=arbol.get_widget("mbd")
	elif global_vars["chapter_to_modify"]["mbd"]==1:
		w=arbol.get_widget("mbd1")
	else:
		w=arbol.get_widget("mbd2")
	w.set_active(True)
	
	if global_vars["chapter_to_modify"]["deinterlace"]=="none":
		w=arbol.get_widget("deinterlace")
	else:
		w=arbol.get_widget("deinterlace_"+global_vars["chapter_to_modify"]["deinterlace"])
	w.set_active(True)
	
	#TODO
	w=arbol.get_widget("ismpeg")
	w.set_active(global_vars["chapter_to_modify"]["ismpeg"])
	
	set_film_buttons(arbol,global_vars)
	
	if global_vars["disctocreate"]=="vcd":
		w=arbol.get_widget("video_rate")
		w.set_value(1152)
		w=arbol.get_widget("audio_rate")
		w.set_value(224)
	elif (global_vars["disctocreate"]=="svcd") or (global_vars["disctocreate"]=="cvd"):
		w=arbol.get_widget("video_rate")
		w.set_range(600,2375)
	
	w=arbol.get_widget("the_notebook")
	w.set_current_page(0)
	
	w=arbol.get_widget("custom_params")
	w.set_text(global_vars["chapter_to_modify"]["params"])
	
	fileaccept=arbol.get_widget("fileaccept")
	fileaccept.set_sensitive(True)
	preview_film2=arbol.get_widget("preview_film")
	preview_film2.set_sensitive(True)
	vrate=arbol.get_widget("video_rate")
	vrate.set_value(global_vars["chapter_to_modify"]["vrate"])
	arate=arbol.get_widget("audio_rate")
	arate.set_value(global_vars["chapter_to_modify"]["arate"])
	w=arbol.get_widget("audiodelay")
	w.set_value(global_vars["chapter_to_modify"]["adelay"])
	if global_vars["chapter_to_modify"]["blackbars"]==0:
		w=arbol.get_widget("blackbars")
		w.set_active(True)
	else:
		w=arbol.get_widget("scalepict")
		w.set_active(True)
		
	w=arbol.get_widget("do_chapters")
	if global_vars["chapter_to_modify"]["lchapters"]==0:
		w.set_active(False)
		w=arbol.get_widget("chapter_long")
		w.set_sensitive(False)
	else:
		w.set_active(True)
		w=arbol.get_widget("chapter_long")
		w.set_sensitive(True)
		w.set_value(global_vars["chapter_to_modify"]["lchapters"])
		
	if global_vars["chapter_to_modify"]["fps"]==25:
		w=arbol.get_widget("video_pal")
	else:
		w=arbol.get_widget("video_ntsc")
	w.set_active(True)
	
	if global_vars["chapter_to_modify"]["cutting"]==0:
		w=arbol.get_widget("full_length")
	elif global_vars["chapter_to_modify"]["cutting"]==1:
		w=arbol.get_widget("first_half")
	else:
		w=arbol.get_widget("second_half")
	w.set_active(True)
	
	w=arbol.get_widget("subtitles_chooser")
	w.unselect_all()
	if global_vars["chapter_to_modify"]["subtitles"]!="":
		w.set_filename(global_vars["chapter_to_modify"]["subtitles"])
		
	w=arbol.get_widget("sub_codepage")
	w.child.set_text(global_vars["chapter_to_modify"]["sub_codepage"])
	w=arbol.get_widget("sub_up")
	w.set_active(global_vars["chapter_to_modify"]["subtitles_up"])
	
	global_vars["current_file"]={}
	filechoser=arbol.get_widget("moviefile")
	filechoser.set_filename(global_vars["chapter_to_modify"]["path"])
	# as soon as we set the filename, there's a SELECTION-CHANGED event, which calls FILECHANGED
	value_changed("",arbol,global_vars) # set the values
	w=arbol.get_widget("aspect_ratio")
	if (global_vars["disctocreate"]=="dvd") or (global_vars["disctocreate"]=="divx"):
		w.set_sensitive(True)
		if global_vars["chapter_to_modify"]["aspect"]>1.6:
			w.set_active(True)
		else:
			w.set_active(False)
	else:
		w.set_sensitive(False)
	global_vars["doing_modify"]=True
	
	wfile.show()
	

def select_first(arbol,structure,global_vars):

	""" Select the first title and the first chapter when we add or erase one """

	wmain=arbol.get_widget("wmain")
	wmain.show()
	global_vars["main_window"]=wmain
	
	ltitles=arbol.get_widget("ltitles")
	ltitles.get_selection().select_path( (0,))
	
	lchapters=arbol.get_widget("lchapters")
	lchapters.get_selection().select_path( (0,))
	
	set_buttons(arbol,structure,global_vars)


def show_titleopts(args,arbol,structure,global_vars):
	
	titulo,capitulo=get_marked(arbol,global_vars)
	w=arbol.get_widget("title_name")
	w.set_text(structure[titulo][0]["nombre"])
	action=structure[titulo][0]["jumpto"]
	if action=="menu":
		w=arbol.get_widget("title_jmenu")
	elif action=="first":
		w=arbol.get_widget("title_jfirst")
	elif action=="prev":
		w=arbol.get_widget("title_jprev")
	elif action=="loop":
		w=arbol.get_widget("title_jthis")
	elif action=="next":
		w=arbol.get_widget("title_jnext")
	elif action=="last":
		w=arbol.get_widget("title_jlast")
	w.set_active(True)
	w=arbol.get_widget("wtitle_properties")
	w.show()


def update_title(args,arbol,structure,global_vars):
	
	titulo,capitulo=get_marked(arbol,global_vars)
	w=arbol.get_widget("title_name")
	structure[titulo][0]["nombre"]=w.get_text()
	
	w=arbol.get_widget("title_jmenu")
	if w.get_active():
		structure[titulo][0]["jumpto"]="menu"
	w=arbol.get_widget("title_jfirst")
	if w.get_active():
		structure[titulo][0]["jumpto"]="first"
	w=arbol.get_widget("title_jprev")
	if w.get_active():
		structure[titulo][0]["jumpto"]="prev"
	w=arbol.get_widget("title_jthis")
	if w.get_active():
		structure[titulo][0]["jumpto"]="loop"
	w=arbol.get_widget("title_jnext")
	if w.get_active():
		structure[titulo][0]["jumpto"]="next"
	w=arbol.get_widget("title_jlast")
	if w.get_active():
		structure[titulo][0]["jumpto"]="last"
	
	w=arbol.get_widget("wtitle_properties")
	w.hide()
	refresh_titles(arbol,structure,global_vars)
	refresh_chapters(arbol,structure,global_vars)


def show_menuopts(args,arbol,global_vars):
	
	w=arbol.get_widget("menu_bg_file")
	menu_filename=global_vars["menu_bg"]
	if menu_filename==None:
		menu_filename=global_vars["path"]+"background.png"
	w.set_filename(menu_filename)
	if global_vars["menu_PAL"]:
		w=arbol.get_widget("menu_pal")
	else:
		w=arbol.get_widget("menu_ntsc")
	w.set_active(True)
	w=arbol.get_widget("menufont")
	w.set_font_name(global_vars["fontname"])
	w=arbol.get_widget("wmenu_properties")
	w.show()
	

def set_default_bg(args,arbol,global_vars):
	
	global_vars["menu_bg"]=global_vars["path"]+"background.png"
	w=arbol.get_widget("menu_bg_file")
	w.set_filename(global_vars["menu_bg"])


def set_new_bg(args,arbol,global_vars):
	
	w=arbol.get_widget("menu_bg_file")
	menu_filename=w.get_filename()
	if menu_filename==None:
		menu_filename=global_vars["path"]+"background.png"
	global_vars["menu_bg"]=menu_filename
	w=arbol.get_widget("menu_pal")
	if w.get_active():
		global_vars["menu_PAL"]=True
	else:
		global_vars["menu_PAL"]=False
	w=arbol.get_widget("menufont")
	global_vars["fontname"]=w.get_font_name()
	w=arbol.get_widget("wmenu_properties")
	w.hide()

###################################
# Other functions not yet grouped #
###################################

def menu_preview_expose(arg,arg2,arbol,structure,global_vars):

	x=global_vars["menu_cr"]
	if x==None:
		return
	cr=x.window.cairo_create()
	sf=global_vars["menu_sf"]
	cr.set_source_surface(global_vars["menu_sf"])
	cr.paint()
	   

def wmenu_preview(args,arbol,structure,global_vars):
	
	w=arbol.get_widget("wmenu_preview")
	x=arbol.get_widget("preview_draw")
	w.show()
	clase=devede_xml_menu.xml_files()
	sf=clase.create_menu_bg(structure,global_vars["menu_bg"],global_vars["menu_PAL"],global_vars["fontname"],"")
	if sf==None:
		w.hide()
		show_error2(_("Can't find the menu background.\nCheck the menu options."),arbol)
		return
	global_vars["menu_sf"]=sf
	global_vars["menu_cr"]=x
	valor=w.run()
	w.hide()
	return

def set_title(arbol,global_vars):
	
	w=arbol.get_widget("wmain")
	nombre=os.path.basename(str(global_vars["struct_name"]))
	if nombre=="":
		nombre=_("Unsaved disc structure")
	w.set_title(nombre+' - DeVeDe')

def devede_save(args,modo,arbol,structure,global_vars):
	
	if modo or (global_vars["struct_name"]==""):
		saveconfig=arbol.get_widget("wsaveconfig")
		saveconfig.show()
		valor=saveconfig.run()
		saveconfig.hide()
		if valor!=-5:
			return
		fname=saveconfig.get_filename()
		if fname==None:
			w=arbol.get_widget("werror_dialog_text")
			w.set_text(_("No filename"))
			w=arbol.get_widget("werror_dialog")
			w.show()
			w.run()
			w.hide()
			return
		if (len(fname)<7) or (fname[-7:]!=".devede"):
			fname+=".devede"
		global_vars["struct_name"]=fname
	
	try:
		output=open(global_vars["struct_name"],"wb")
		id="DeVeDe"
		pickle.dump(id,output)
		pickle.dump(structure,output)
		vars={}
		vars["disctocreate"]=global_vars["disctocreate"]
		vars["titlecounter"]=global_vars["titlecounter"]
		vars["do_menu"]=global_vars["do_menu"]
		vars["currentfileselected"]=global_vars["currentfileselected"]
		vars["menu_widescreen"]=global_vars["menu_widescreen"]
		vars["PAL"]=global_vars["PAL"]
		vars["menu_bg"]=global_vars["menu_bg"]
		vars["menu_PAL"]=global_vars["menu_PAL"]
		vars["struct_name"]=global_vars["struct_name"]
		vars["fontname"]=global_vars["fontname"]
		pickle.dump(vars,output)
		output.close()
	except:
		w=arbol.get_widget("werror_dialog_text")
		w.set_text(_("Can't save the file."))
		w=arbol.get_widget("werror_dialog")
		w.show()
		w.run()
		w.hide()
		set_title(arbol,global_vars)
		return


def devede_open(args,arbol,structure,global_vars):
	
	if (len(structure)>1) or (len(structure[0])>1):
		loosecurrent=arbol.get_widget("wloosecurrent")
		loosecurrent.show()
		valor=loosecurrent.run()
		loosecurrent.hide()
		if valor!=-5:
			return
	
	chosefile=arbol.get_widget("wloadconfig")
	chosefile.show()
	valor=chosefile.run()
	chosefile.hide()
	
	if valor!=-5:
		return
	
	try:
		output=open(chosefile.get_filename())
	except:
		w=arbol.get_widget("werror_dialog_text")
		w.set_text(_("Can't open the file."))
		w=arbol.get_widget("werror_dialog")
		w.show()
		w.run()
		w.hide()
		return

	try:
		valores=pickle.load(output)
	except:
		w=arbol.get_widget("werror_dialog_text")
		w.set_text(_("That file doesn't contain a disc structure."))
		
		w=arbol.get_widget("werror_dialog")
		w.show()
		w.run()
		w.hide()
		return
	
	if valores!="DeVeDe":
		w=arbol.get_widget("werror_dialog_text")
		w.set_text(_("That file doesn't contain a disc structure."))
		
		w=arbol.get_widget("werror_dialog")
		w.show()
		w.run()
		w.hide()
		return
	
	global_vars2={}
	try:
		valores=pickle.load(output)
		global_vars2=pickle.load(output)
	except:
		w=arbol.get_widget("werror_dialog_text")
		w.set_text(_("That file doesn't contain a DeVeDe structure."))
		w=arbol.get_widget("werror_dialog")
		w.show()
		w.run()
		w.hide()
		return

	output.close()
	
	not_found=[]
	for elemento in valores:
		for elemento2 in elemento[1:]:
			try:
				v=os.stat(elemento2["path"])
			except:
				not_found.append(str(elemento2["path"]))

	if len(not_found)!=0:
		cadena=_("Can't find the following movie files. Please, add them and try to load the disc structure again.\n")
		for elemento in not_found:
			cadena+="\n"+elemento
		w=arbol.get_widget("werror_dialog_text")
		w.set_text(cadena)
		w=arbol.get_widget("werror_dialog")
		w.show()
		w.run()
		w.hide()
		return
	
	try:
		os.stat(global_vars2["menu_bg"])
	except:
		w=arbol.get_widget("wwarning_dialog_text")
		w.set_text(_("Can't find the menu background. I'll open the disc structure anyway with the default menu background, so don't forget to fix it before creating the disc."))
		w=arbol.get_widget("wwarning_dialog")
		global_vars2["menu_bg"]=global_vars["path"]+"background.png"
		w.show()
		w.run()
		w.hide()
	
	while (len(structure)>0):
		structure.pop()
	
	for elemento in valores:
		structure.append(elemento)
	for elemento in global_vars2:
		global_vars[elemento]=global_vars2[elemento]
	
	w=arbol.get_widget("domenu")
	w.set_active(global_vars["do_menu"])
	refresh_titles(arbol,structure,global_vars)
	refresh_chapters(arbol,structure,global_vars)
	set_buttons(arbol,structure,global_vars)
	set_title(arbol,global_vars)
	set_disk_type(arbol,structure,global_vars)


def titlecancel(args,arbol):
	
	w=arbol.get_widget("wtitle_properties")
	w.hide()


def menucancel(args,arbol):
	
	w=arbol.get_widget("wmenu_properties")
	w.hide()


def menutogled(args,arbol,global_vars):

	w=arbol.get_widget("domenu")
	w2=arbol.get_widget("menuoptions")
	w2.set_sensitive(w.get_active())
	global_vars["do_menu"]=w.get_active()


def noabort(args,arbol):

	wcancel=arbol.get_widget("wcancel")
	wcancel.hide()


def siabort(args):

	gtk.main_quit()


def delete_title(args,arbol,structure,global_vars):

	""" Callback for the delete title confirmation button. It deletes
	the title and all the chapters contained there """

	titulo,capitulo=get_marked(arbol,global_vars)
	
	structure.pop(titulo)

	refresh_titles(arbol,structure,global_vars)
	set_buttons(arbol,structure,global_vars)
	refresh_chapters(arbol,structure,global_vars)

	wdel_title=arbol.get_widget("wdel_title")
	wdel_title.hide()


def no_delete_title(args,arbol):

	""" Callback for the delete title abort button. It just hides the
	confirmation dialog """

	wdel_title=arbol.get_widget("wdel_title")
	wdel_title.hide()


def chaptercancel(args,arbol):

	wfile=arbol.get_widget("wfile")
	wfile.hide()


def value_changed(args,arbol,global_vars):

	set_final_size(arbol,global_vars)
	refresh_film_data(arbol,global_vars)


def value_changed2(args,arbol,global_vars):

	refresh_film_data(arbol,global_vars)
	
def value_changed3(args,arbol,global_vars):

	""" called when the user changes the final resolution """
	
	value_changed("",arbol,global_vars)

	if (global_vars["disctocreate"]!="dvd"):
		return
	if len(global_vars["current_file"])==0:
		return
	if global_vars["current_file"]["width"]!=720:
		w=arbol.get_widget("aspect_ratio")
		w.set_active(False)
		
def value_changed4(args,arbol,global_vars):

	""" called when the user activates the 16:9 aspect ratio """
	
	w=arbol.get_widget("aspect_ratio")
	if False==w.get_active():
		return
	if (global_vars["disctocreate"]=="divx"):
		return
	value_changed("",arbol,global_vars)
	if len(global_vars["current_file"])==0:
		return
	if global_vars["current_file"]["width"]!=720:
		w=arbol.get_widget("res720x480")
		w.set_active(True)
		value_changed("",arbol,global_vars)

def ismpeg_changed(args,arbol,global_vars):

	set_film_buttons(arbol,global_vars)
	refresh_film_data(arbol,global_vars)


def set_film_buttons(arbol,global_vars):

	w=arbol.get_widget("ismpeg")
	if w.get_active():
		grupo2=False
	else:
		grupo2=True

	if global_vars["disctocreate"]=="vcd":
		grupo1=False
	else:
		grupo1=grupo2
	
	grupo3=grupo2
	try:
		if global_vars["current_file"]["olength"]<60:
			grupo3=False
	except:
		grupo3=False

	w=arbol.get_widget("video_rate")
	w.set_sensitive(grupo1)
	w=arbol.get_widget("audio_rate")
	w.set_sensitive(grupo1)
	w=arbol.get_widget("resauto")
	w.set_sensitive(grupo1)
	w=arbol.get_widget("res352x240")
	w.set_sensitive(grupo1)
	w=arbol.get_widget("res352x480")
	w.set_sensitive(grupo1)
	w=arbol.get_widget("res480x480")
	w.set_sensitive(grupo1)
	w=arbol.get_widget("res704x480")
	w.set_sensitive(grupo1)
	w=arbol.get_widget("res720x480")
	w.set_sensitive(grupo1)
	
	w=arbol.get_widget("full_length")
	w.set_sensitive(grupo3)
	w=arbol.get_widget("first_half")
	w.set_sensitive(grupo3)
	w=arbol.get_widget("second_half")
	w.set_sensitive(grupo3)
	w=arbol.get_widget("video_pal")
	w.set_sensitive(grupo2)
	w=arbol.get_widget("video_ntsc")
	w.set_sensitive(grupo2)
	w=arbol.get_widget("audiodelay")
	w.set_sensitive(grupo2)
	w=arbol.get_widget("blackbars")
	w.set_sensitive(grupo2)
	w=arbol.get_widget("scalepict")
	w.set_sensitive(grupo2)
	w=arbol.get_widget("custom_params")
	w.set_sensitive(grupo2)
	w=arbol.get_widget("trell")
	w.set_sensitive(grupo2)
	w=arbol.get_widget("mbd")
	w.set_sensitive(grupo2)
	w=arbol.get_widget("mbd1")
	w.set_sensitive(grupo2)
	w=arbol.get_widget("mbd2")
	w.set_sensitive(grupo2)
	w=arbol.get_widget("deinterlace")
	w.set_sensitive(grupo2)
	w=arbol.get_widget("deinterlace_lb")
	w.set_sensitive(grupo2)
	w=arbol.get_widget("deinterlace_md")
	w.set_sensitive(grupo2)
	w=arbol.get_widget("deinterlace_fd")
	w.set_sensitive(grupo2)
	

def errorok(args,arbol):

	werror=arbol.get_widget("werror")
	werror.hide()


def delete_chapter_no(args,arbol):

	wdel_chapter=arbol.get_widget("wdel_chapter")
	wdel_chapter.hide()


def delete_chapter_yes(args,arbol,structure,global_vars):

	wdel_chapter=arbol.get_widget("wdel_chapter")
	wdel_chapter.hide()
	
	titulo,capitulo=get_marked(arbol,global_vars)

	structure[titulo].pop(capitulo)
	
	refresh_chapters(arbol,structure,global_vars)
	set_buttons(arbol,structure,global_vars)


def chapter_changed(args,arbol):

	w=arbol.get_widget("chapter_long")
	w.set_sensitive(args.get_active())


def window_new(args,arbol):
	
	w=arbol.get_widget("werase")
	w.show()
	
def newno(args,arbol):
	
	w=arbol.get_widget("werase")
	w.hide()
	
def create_new_structure():
	
	nombre=_("Title")
	nombre+=" 1"
	var={}
	var["nombre"]=nombre
	var["jumpto"]="menu"
	return [var]


def set_default_global(global_vars):
	
	global_vars["fontname"]="Sans 12"
	global_vars["allowmenu"]=True
	global_vars["struct_name"]=""
	global_vars["do_menu"]=True
	global_vars["menu_bg"]=pic_path+"background.png"
	global_vars["titlecounter"]=2
	global_vars["currentfileselected"]=0
	global_vars["currenttitleselected"]=-2


def newyes(args,arbol,structure,global_vars):
	
	while (len(structure)>0):
		structure.pop()
	structure.append(create_new_structure())
	set_default_global(global_vars)
	
	refresh_titles(arbol,structure,global_vars)
	refresh_chapters(arbol,structure,global_vars)
	
	w=arbol.get_widget("werase")
	w.hide()
	
	w = arbol.get_widget("disk_type")
	w.show()


def cancel_progress(args,arbol):
	
	w=arbol.get_widget("wcanceljob")
	w.show()

def cancel_progressyes(args,arbol,global_vars):

	global_vars["cancel_prog"]=True
	w=arbol.get_widget("wcanceljob")
	w.hide()

def cancel_progressno(args,arbol):

	w=arbol.get_widget("wcanceljob")
	w.hide()


def return_main(args,arbol):

	w=arbol.get_widget("w_aborted")
	w.hide()
	w=arbol.get_widget("wmain")	
	w.show()


def return_main2(args,arbol):

	w=arbol.get_widget("werror2")
	w.hide()
	w=arbol.get_widget("wmain")	
	w.show()


def exit_program(args):

	gtk.main_quit()


def preview_film(args,arbol,global_vars):

	set_file_values(arbol,global_vars)
	global_vars["erase_temporary_files"]=True
	global_vars["number_actions"]=1
	tmp_structure=[["",global_vars["current_file"]]]
	converter=devede_convert.create_all(tmp_structure,global_vars)
	global_vars["temp_folder"]=converter.preview(global_vars["temp_folder"])


def set_disk_type(arbol,structure,global_vars):
	
	w = arbol.get_widget("disk_type")
	w.hide()
	
	dtc = global_vars["disctocreate"]
	
	w = arbol.get_widget("dvdsize")
	if (dtc == "dvd") or (dtc == "divx"):
		w.set_active(4)
	else:
		w.set_active(2)

	w = arbol.get_widget("subtitles_frame")
	if (dtc == "divx"):
		w.hide()
	else:
		w.show()
		
	w = arbol.get_widget("subtitles_label")
	if (dtc == "divx"):
		w.show()
	else:
		w.hide()
		
	
	global_vars["allowmenu"] = True
	
	w1 = arbol.get_widget("frame1")
	w2 = arbol.get_widget("create_dvd")
	w3 = arbol.get_widget("frame_division")
	w4 = arbol.get_widget("domenu")
	w5 = arbol.get_widget("menuoptions")
	w6 = arbol.get_widget("menu_preview")
	if dtc == "dvd":
		global_vars["do_menu"] = True
		w = arbol.get_widget("domenu")
		w.set_active(True)
		w1.show()
		w2.show()
		w3.show()
		w4.show()
		w5.show()
		w6.show()
	else:
		w1.hide()
		w2.hide()
		w3.hide()
		w4.hide()
		w5.hide()
		w6.hide()
		global_vars["do_menu"] = False
		w = arbol.get_widget("domenu")
		w.set_active(False)
	
	select_first(arbol,structure,global_vars)

	w1 = arbol.get_widget("frame5")
	w2 = arbol.get_widget("frame19")
	w3 = arbol.get_widget("frame_special")
	if dtc == "divx":
		w1.hide()
		w2.hide()
		w3.hide()
		w = arbol.get_widget("only_convert")
		w.set_active(True)
	else:
		w1.show()
		w2.show()
		w3.show()
		w=arbol.get_widget("create_iso")
		w.set_active(True)
	
	w=arbol.get_widget("erase_files")
	w.set_active(True)

	refresh_titles(arbol,structure,global_vars)
	refresh_chapters(arbol,structure,global_vars)
	set_title(arbol,global_vars)


def ask_disk_type(args,arbol,structure,global_vars):
	
	w = arbol.get_widget("disk_type")
	w.show()
	

def dvd_clicked(args,arbol,structure,global_vars):

	global_vars["disctocreate"]="dvd"
	set_disk_type(arbol,structure,global_vars)
	
def vcd_clicked(args,arbol,structure,global_vars):

	global_vars["disctocreate"]="vcd"
	set_disk_type(arbol,structure,global_vars)

def svcd_clicked(args,arbol,structure,global_vars):

	global_vars["disctocreate"]="svcd"
	set_disk_type(arbol,structure,global_vars)

def cvd_clicked(args,arbol,structure,global_vars):

	global_vars["disctocreate"]="cvd"
	set_disk_type(arbol,structure,global_vars)

def divx_clicked(args,arbol,structure,global_vars):

	global_vars["disctocreate"]="divx"
	set_disk_type(arbol,structure,global_vars)


def init_main(arbol,structure,global_vars):

	""" Sets all the callbacks """

	# First Window that opens up giving choice between video dvd, video cd, etc...
	
	w = arbol.get_widget("typedvd")
	w.connect("clicked",dvd_clicked,arbol,structure,global_vars)
	w = arbol.get_widget("typevcd")
	w.connect("clicked",vcd_clicked,arbol,structure,global_vars)
	w = arbol.get_widget("typesvcd")
	w.connect("clicked",svcd_clicked,arbol,structure,global_vars)
	w = arbol.get_widget("typecvd")
	w.connect("clicked",cvd_clicked,arbol,structure,global_vars)
	w = arbol.get_widget("typedivx")
	w.connect("clicked",divx_clicked,arbol,structure,global_vars)
	
	title_down=arbol.get_widget("titledown")
	title_down.connect("clicked",titledown,arbol,structure,global_vars)
	
	title_up=arbol.get_widget("titleup")
	title_up.connect("clicked",titleup,arbol,structure,global_vars)
	
	files_down=arbol.get_widget("filesdown")
	files_down.connect("clicked",filesdown,arbol,structure,global_vars)
	
	files_up=arbol.get_widget("filesup")
	files_up.connect("clicked",filesup,arbol,structure,global_vars)
	
	wprogress=arbol.get_widget("wprogress")
	wprogress.connect("delete_event",alwaystrue)
	
	wabout=arbol.get_widget("aboutdialog1")
	wabout.connect("delete_event",global_delete)
	
	wcancel=arbol.get_widget("wcancel")
	wcancel.connect("delete_event",global_delete)
	
	# Main window that allows adding videos and titles
	wmain=arbol.get_widget("wmain")
	wmain.connect("delete_event",wmain_delete,arbol)
	
	w=arbol.get_widget("main_cancel")
	w.connect("clicked",wmain_delete2,arbol)
	
	w=arbol.get_widget("prog_cancel")
	w.connect("clicked",cancel_progress,arbol)
	
	ltitles=arbol.get_widget("ltitles")
	lchapters=arbol.get_widget("lchapters")
	
	wmain.drag_dest_set(gtk.DEST_DEFAULT_MOTION | gtk.DEST_DEFAULT_HIGHLIGHT | gtk.DEST_DEFAULT_DROP,[ ( "text/plain", 0, 80 ) ],gtk.gdk.ACTION_COPY)
	wmain.connect("drag_data_received",draganddrop,arbol,structure,global_vars)
	
	ltitles.set_model(global_vars["list_titles"])
	lchapters.set_model(global_vars["list_chapters"])
	
	renderertitles=gtk.CellRendererText()
	columntitles = gtk.TreeViewColumn("Title", renderertitles, text=1)
	ltitles.append_column(columntitles)
	
	rendererchapters=gtk.CellRendererText()
	columnchapters = gtk.TreeViewColumn("Title", rendererchapters, text=1)
	lchapters.append_column(columnchapters)
	
	ltitles.connect("button_release_event",titleclick,arbol,structure,global_vars)
	lchapters.connect("button_release_event",chapterclick,arbol,structure,global_vars)
	
	# Main window buttons callbacks
	add_title=arbol.get_widget("add_title")
	add_title.connect("clicked",addtitle,arbol,structure,global_vars)
	del_title=arbol.get_widget("del_title")
	del_title.connect("clicked",deltitle,arbol,structure,global_vars)
	# button for adding files
	add_chapter=arbol.get_widget("add_chapter") 
	add_chapter.connect("clicked",addchapter,arbol,global_vars)
	del_chapter=arbol.get_widget("del_chapter")
	del_chapter.connect("clicked",delete_chapter,arbol,structure,global_vars)
	prop_chapter=arbol.get_widget("prop_chapter")
	prop_chapter.connect("clicked",modify_chapter,arbol,structure,global_vars)
	main_go=arbol.get_widget("main_go")
	main_go.connect("clicked",create_dvd,arbol,structure,global_vars)
	
	w=arbol.get_widget("create_iso")
	w.set_active(True)
	
	wdel_title=arbol.get_widget("wdel_title")
	wdel_title.connect("delete_event",global_delete)
	w=arbol.get_widget("deltitle_yes")
	w.connect("clicked",delete_title,arbol,structure,global_vars)
	w=arbol.get_widget("deltitle_no")
	w.connect("clicked",no_delete_title,arbol)
	
	wdel_chapter=arbol.get_widget("wdel_chapter")
	wdel_chapter.connect("delete_event",global_delete)
	w=arbol.get_widget("delchapter_yes")
	w.connect("clicked",delete_chapter_yes,arbol,structure,global_vars)
	w=arbol.get_widget("delchapter_no")
	w.connect("clicked",delete_chapter_no,arbol)

	w=arbol.get_widget("dvdsize")
	w.set_active(0)
	w.connect("changed",dvd_changed,arbol,structure,global_vars)
	
	wfile=arbol.get_widget("wfile")
	wfile.connect("delete_event",global_delete)
	wfile.drag_dest_set(gtk.DEST_DEFAULT_MOTION | gtk.DEST_DEFAULT_HIGHLIGHT | gtk.DEST_DEFAULT_DROP,[ ( "text/plain", 0, 80 ) ],gtk.gdk.ACTION_COPY)
	wfile.connect("drag_data_received",draganddrop_two,arbol)
	
	w=arbol.get_widget("filecancel")
	w.connect("clicked",chaptercancel,arbol)
	w=arbol.get_widget("moviefile")
	w.connect("selection-changed",filechanged,arbol,global_vars)
	file_filter3=gtk.FileFilter()
	file_filter3.set_name(_("Video files"))
	file_filter3.add_mime_type("video/*")
	file_filter4=gtk.FileFilter()
	file_filter4.set_name(_("All files"))
	file_filter4.add_pattern("*")
	w.add_filter(file_filter3)
	w.add_filter(file_filter4)
	
	werror=arbol.get_widget("werror")
	werror.connect("delete_event",global_delete)
	w=arbol.get_widget("error_ok")
	w.connect("clicked",errorok,arbol)
	
	w=arbol.get_widget("video_rate")
	w.connect("value_changed",value_changed2,arbol,global_vars)
	w=arbol.get_widget("audio_rate")
	w.connect("value_changed",value_changed2,arbol,global_vars)
	w=arbol.get_widget("video_pal")
	w.connect("toggled",value_changed,arbol,global_vars)
	
	w=arbol.get_widget("fileaccept")
	w.connect("clicked",add_a_file,arbol,structure,global_vars)
	
	w=arbol.get_widget("do_chapters")
	w.connect("clicked",chapter_changed,arbol)
	
	w=arbol.get_widget("msgno")
	w.connect("clicked",noabort,arbol)
	w=arbol.get_widget("msgyes")
	w.connect("clicked",siabort)

	
	w=arbol.get_widget("error2_button")
	w.connect("clicked",return_main2,arbol)
	w=arbol.get_widget("werror2")
	w.connect("delete_event",alwaystrue)
	
	wprograms=arbol.get_widget("wprograms")
	wprograms.connect("delete_event",alwaystrue)
	w=arbol.get_widget("program_exit")
	w.connect("clicked",exit_program)
	
	w=arbol.get_widget("preview_film")
	w.connect("clicked",preview_film,arbol,global_vars)
	
	w=arbol.get_widget("full_length")
	w.connect("toggled",value_changed2,arbol,global_vars)
	
	w=arbol.get_widget("first_half")
	w.connect("toggled",value_changed2,arbol,global_vars)
	
	w=arbol.get_widget("resauto")
	w.set_active(True)
	w.connect("toggled",value_changed3,arbol,global_vars)
	w=arbol.get_widget("res720x480")
	w.connect("toggled",value_changed3,arbol,global_vars)
	w=arbol.get_widget("res704x480")
	w.connect("toggled",value_changed3,arbol,global_vars)
	w=arbol.get_widget("res480x480")
	w.connect("toggled",value_changed3,arbol,global_vars)
	w=arbol.get_widget("res352x480")
	w.connect("toggled",value_changed3,arbol,global_vars)
	w=arbol.get_widget("res352x240")
	w.connect("toggled",value_changed3,arbol,global_vars)

	w=arbol.get_widget("aspect_ratio")
	w.connect("toggled",value_changed4,arbol,global_vars)

	w=arbol.get_widget("ismpeg")
	w.connect("toggled",ismpeg_changed,arbol,global_vars)
	
	w=arbol.get_widget("expander_advanced")
	w.set_expanded(False)
	w=arbol.get_widget("clear_subtitles")
	w.connect("clicked",clear_subtitles,arbol)
	
	w=arbol.get_widget("wtitle_properties")
	w.connect("delete_event",global_delete)
	w=arbol.get_widget("title_cancel")
	w.connect("clicked",titlecancel,arbol)
	w=arbol.get_widget("prop_titles")
	w.connect("clicked",show_titleopts,arbol,structure,global_vars)
	w=arbol.get_widget("title_accept")
	w.connect("clicked",update_title,arbol,structure,global_vars)

	w=arbol.get_widget("wmenu_properties")
	w.connect("delete_event",global_delete)
	w=arbol.get_widget("menu_cancel")
	w.connect("clicked",menucancel,arbol)
	w=arbol.get_widget("domenu")
	w.connect("toggled",menutogled,arbol,global_vars)
	w=arbol.get_widget("menuoptions")
	w.connect("clicked",show_menuopts,arbol,global_vars)
	w=arbol.get_widget("menu_default_bg")
	w.connect("clicked",set_default_bg,arbol,global_vars)
	w=arbol.get_widget("menu_accept")
	w.connect("clicked",set_new_bg,arbol,global_vars)
	
	w=arbol.get_widget("devede_new")
	w.connect("activate",window_new,arbol)
	w=arbol.get_widget("newno")
	w.connect("clicked",newno,arbol)
	w=arbol.get_widget("newyes")
	w.connect("clicked",newyes,arbol,structure,global_vars)
	
	w=arbol.get_widget("devede_about")
	w.connect("activate",show_about,arbol)
	
	w=arbol.get_widget("devede_quit")
	w.connect("activate",wmain_delete2,arbol)
	
	w=arbol.get_widget("devede_open")
	w.connect("activate",devede_open,arbol,structure,global_vars)
	
	w=arbol.get_widget("devede_save")
	w.connect("activate",devede_save,False,arbol,structure,global_vars)
	
	w=arbol.get_widget("devede_saveas")
	w.connect("activate",devede_save,True,arbol,structure,global_vars)
	
	filter=gtk.FileFilter()
	#filter.add_pattern("*.png")
	filter.add_mime_type("image/png")
	filter.set_name("PNG pictures")
	w=arbol.get_widget("menu_bg_file")
	w.add_filter(filter)
	
	filter=gtk.FileFilter()
	filter.add_pattern("*.devede")
	filter.set_name(".devede")
	w=arbol.get_widget("wsaveconfig")
	w.add_filter(filter)
	w.set_do_overwrite_confirmation(True)
	
	filter=gtk.FileFilter()
	filter.add_pattern("*.devede")
	filter.set_name(".devede")
	w=arbol.get_widget("wloadconfig")
	w.add_filter(filter)
	
	w=arbol.get_widget("menu_preview")
	w.connect("clicked",wmenu_preview,arbol,structure,global_vars)
	w=arbol.get_widget("preview_draw")
	w.connect("expose-event",menu_preview_expose,arbol,structure,global_vars)

	refresh_titles(arbol,structure,global_vars)
	set_buttons(arbol,structure,global_vars)
	set_title(arbol,global_vars)

# TODO Change the following to work on both linux and windows
# add detection to get_win32_home_directory for win and linux and change it to
# get_home_directory

home=get_home_directory()

#locale.setlocale(locale.LC_ALL,"")
#gettext.textdomain('devede')
#_ = gettext.gettext

# global variables used (they are stored in a single dictionary to avoid true global variables):

# list_titles
# list_chapters
# chapter_to_modify
# current_file
# cancel_prog
# titlecounter
# currentfileselected
# currenttitleselected
# PAL
# disctocreate

# there are these two that aren't stored in the dictionary because they are very widely used:
# arbol
# structure

global_vars={}

if pic_path[-1]!=os.sep:
	pic_path+=os.sep

global_vars["chapter_to_modify"]={}
global_vars["current_file"]={}
global_vars["cancel_prog"]=False
global_vars["PAL"]=True
global_vars["disctocreate"]=""
global_vars["list_titles"]=gtk.TreeStore(gobject.TYPE_PYOBJECT,gobject.TYPE_STRING)
global_vars["list_chapters"]=gtk.TreeStore(gobject.TYPE_PYOBJECT,gobject.TYPE_STRING)
global_vars["doing_modify"]=False
global_vars["path"]=pic_path
global_vars["menu_widescreen"]=False
global_vars["menu_PAL"]=True
global_vars["menu_cr"]=None
global_vars["menu_sf"]=None
global_vars["gladefile"]=glade
set_default_global(global_vars)

if font_path[-1]!=os.sep:
	font_path+=os.sep
font_path+="devedesans.ttf"
global_vars["font_path"]=font_path

#if our font for subtitles isn't installed, we install it

#TODO
try:
	if not sys.platform=='win32':
		fichero=open(home+".spumux/devedesans.ttf")
		fichero.close()
	else: # get home		
		#t=os.path.split(home)[0]+os.sep+"spumux"+os.sep+"devedesans.ttf"
		t=r'C:\WINDOWS\Fonts\devedesans.tff'
		fichero=open(t)
		fichero.close()
except:
	#TODO
	if sys.platform=='win32':
		#t = os.path.split(os.path.split(home)[0])[0]+os.sep+"spumux"
		t=os.path.join("C:\WINDOWS", "Fonts" )#=r'C:\WINDOWS\Fonts\\'
		# spummux needs font in the windows font directory
		print "\n\nFont Path: " , font_path
		print "\n\nT: " , t
		if not os.path.isdir(t):
			os.mkdir(t)
		shutil.copyfile(font_path,t+os.sep+"devedesans.ttf")
	else:
		handle=subprocess.Popen("mkdir "+home+".spumux",bufsize=8192,shell=True)
		handle.wait()
		handle=subprocess.Popen("cp "+font_path+" "+home+".spumux/",bufsize=8192,shell=True)
		handle.wait()

	

load_config(global_vars)

structure=[]
structure.append(create_new_structure())

init_main(arbol,structure,global_vars)

errors=""
if not sys.platform=='win32':
	if 127==check_program("mplayer -v"):
		errors+="mplayer\n"
	if 127==check_program("mencoder -msglevel help"):
		errors+="mencoder\n"
	if 127==check_program("dvdauthor --help"):
		errors+="dvdauthor\n"
	if 127==check_program("vcdimager --help"):
		errors+="vcdimager\n"
	if 127==check_program("mkisofs -help"):
		errors+="mkisofs\n"
	if 127==check_program("spumux --help"):
		errors+="spumux\n"
else:
	
	try:
		check_program(["mplayer.exe", "-v"])
	except:
		errors+="mplayer\n"
	try:
		check_program(["mencoder.exe", "-msglevel", "help"])
	except:
		errors+="mencoder\n"
	try:
		check_program(["dvdauthor.exe", "--help"])
	except:
		errors+="dvdauthor\n"
	try:
		check_program(["vcdimager.exe", "--help"])
	except:
		errors+="vcdimager\n"
	try:
		check_program(["mkisofs.exe"])
	except:
		errors+="mkisofs\n"
	try:
		check_program(["spumux.exe", "--help"])
	except:
		errors+="spumux\n"


if errors!="":
	w=arbol.get_widget("programs_label")
	w.set_text(errors)
	wprograms=arbol.get_widget("wprograms")
	wprograms.show()
else:
	ask_disk_type(None,arbol,structure,global_vars)

gtk.main()
save_config(global_vars)
