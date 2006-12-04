default:

install:
	install 50_guadalinex_noodle ${DESTDIR}/usr/share/gconf/defaults
	install 60-ipaq.rules ${DESTDIR}/etc/udev/rules.d
	install psuite*	${DESTDIR}/usr/bin
	install examples/* ${DESTDIR}/usr/share/guadalinex-noodle/

uninstall:
	rm -f ${DESTDIR}/usr/share/gconf/defaults/50_guadalinex_noodle
	rm -f ${DESTDIR}/etc/udev/rules.d/60-ipaq.rules
	rm -f ${DESTDIR}/usr/bin/psuite
	rm -f ${DESTDIR}/usr/bin/psuite-user
	rm -f ${DESTDIR}/usr/bin/psuite-first-time
	rm -f ${DESTDIR}/usr/share/guadalinex-noodle/*
