default:

install:
	install 50_guadalinex_noodle ${DESTDIR}/usr/share/gconf/defaults/
	install 60-*.rules ${DESTDIR}/etc/udev/rules.d/
	install psuite	${DESTDIR}/usr/bin/
	install psuiteuser.py	${DESTDIR}/usr/bin/psuiteuser
	install examples/* ${DESTDIR}/usr/share/guadalinex-noodle/
	install vdccm.desktop ${DESTDIR}/etc/xdg/autostart/
	install dun ${DESTDIR}/etc/ppp/peers/

uninstall:
	rm -f ${DESTDIR}/usr/share/gconf/defaults/50_guadalinex_noodle
	rm -f ${DESTDIR}/etc/udev/rules.d/60-ipaq.rules
	rm -f ${DESTDIR}/etc/udev/rules.d/60-bluetooth.rules
	rm -f ${DESTDIR}/usr/bin/psuite
	rm -f ${DESTDIR}/usr/bin/psuite-user
	rm -f ${DESTDIR}/usr/bin/psuite-first-time
	rm -f ${DESTDIR}/usr/share/guadalinex-noodle/*
	rm -f ${DESTDIR}/etc/xdg/autostart/vdccm.desktop
