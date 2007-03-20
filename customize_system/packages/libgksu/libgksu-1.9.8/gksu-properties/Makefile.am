AM_CFLAGS = -g -O2 -Wall
INCLUDES = ${GKSU_PROPERTIES_CFLAGS}
AM_CPPFLAGS = -DLOCALEDIR=\"$(datadir)/locale\" -DDATA_DIR=\"$(datadir)\" -DPREFIX=\"$(prefix)\"

bin_PROGRAMS = gksu-properties
gksu_properties_LDFLAGS = ${GKSU_PROPERTIES_LIBS}
gksu_properties_SOURCES = gksu-properties.c

gladedir = ${prefix}/share/${PACKAGE}
glade_DATA = gksu-properties.glade

@INTLTOOL_DESKTOP_RULE@

desktopdir = $(datadir)/applications
Desktop_in_files = gksu-properties.desktop.in
desktop_DATA = $(Desktop_in_files:.desktop.in=.desktop)

EXTRA_DIST = $(glade_DATA) $(Desktop_in_files)
