dnl Process this file with autoconf to produce a configure script.
AC_PREREQ(2.53)

AC_INIT(synce-software-manager, 0.9.0)
AM_INIT_AUTOMAKE(AC_PACKAGE_NAME, 0.9.0)
AC_CONFIG_SRCDIR(src/main.c)

AM_CONFIG_HEADER(config.h)

dnl GNOME_INIT
pkg_modules="gtk+-2.0 glib-2.0 libgnomeui-2.0 libglade-2.0"
PKG_CHECK_MODULES(GTK2, [$pkg_modules])
AC_SUBST(GTK2_CFLAGS)
AC_SUBST(GTK2_LIBS)

AC_SUBST(APPLE_CFLAGS)
case $target in

	powerpc-apple-*)
		dnl Prevent "Undefined Macro argument list" error.
		APPLE_CFLAGS="-no-cpp-precomp"
		;;

	*)
		APPLE_CFLAGS=""
		;;

esac

dnl Checks for programs.
AC_PROG_CC
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_LIBTOOL
AC_PROG_MAKE_SET

dnl Check for SynCE libs
dnl AM_PATH_LIBSYNCE
AM_PATH_LIBRAPI2
dnl AM_PATH_RRA

dnl Prevent "NONE" used as prefix!
if test "x$prefix" = xNONE; then
  prefix=$ac_default_prefix
fi
GLADEFILE="${datadir}/synce/synce_software_manager.glade"
eval SYNCE_SOFTWARE_MANAGER_GLADEFILE="$GLADEFILE"
AC_DEFINE_UNQUOTED(SYNCE_SOFTWARE_MANAGER_GLADEFILE, "$SYNCE_SOFTWARE_MANAGER_GLADEFILE",[The glade file used by the program])

dnl Checks for header files.

dnl Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST

AC_SUBST(CFLAGS)
AC_SUBST(CPPFLAGS)
AC_SUBST(LDFLAGS)


dnl i18n stuff
ALL_LINGUAS="sv ru"
                                                                                
GETTEXT_PACKAGE=AC_PACKAGE_NAME
AC_SUBST(GETTEXT_PACKAGE)
AC_DEFINE_UNQUOTED(GETTEXT_PACKAGE, "$GETTEXT_PACKAGE", [foo])
                                                                                
AM_GLIB_GNU_GETTEXT
AC_PROG_INTLTOOL
                                                                                
if test "x${prefix}" = "xNONE"; then
    AC_DEFINE_UNQUOTED(LOCALEDIR, "${ac_default_prefix}/${DATADIRNAME}/locale", [Locale dir])
    else
        AC_DEFINE_UNQUOTED(LOCALEDIR, "${prefix}/${DATADIRNAME}/locale", [Locale dir])
fi
                                                                                
AC_OUTPUT([
		   Makefile
		   src/Makefile
           data/Makefile
		   po/Makefile.in
])

