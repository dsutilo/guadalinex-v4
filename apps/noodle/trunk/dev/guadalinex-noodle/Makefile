default:

install:
	install -D 50_guadalinex_noodle ${DESTDIR}/usr/share/gconf/defaults/
	install -D 60-*.rules ${DESTDIR}/etc/udev/rules.d/
	install -D psuite	${DESTDIR}/usr/bin/
	install -D psuiteuser.py	${DESTDIR}/usr/bin/psuiteuser
	mkdir -p /usr/share/guadalinex-noodle/ && cp -r examples/ ${DESTDIR}/usr/share/guadalinex-noodle/
	cp -r img/ ${DESTDIR}/usr/share/guadalinex-noodle/
	install -D vdccm.desktop ${DESTDIR}/etc/xdg/autostart/
	install -D examples/dun ${DESTDIR}/etc/ppp/peers/
	install -D src/noodle.py ${DESTDIR}/usr/bin
	install -D src/noodle.glade ${DESTDIR}/usr/share/guadalinex-noodle/

uninstall:
	rm -f ${DESTDIR}/usr/share/gconf/defaults/50_guadalinex_noodle
	rm -f ${DESTDIR}/etc/udev/rules.d/60-ipaq.rules
	rm -f ${DESTDIR}/etc/udev/rules.d/60-bluetooth.rules
	rm -f ${DESTDIR}/usr/bin/psuite
	rm -f ${DESTDIR}/usr/bin/psuite-user
	rm -f ${DESTDIR}/usr/bin/psuite-first-time
	rm -fr ${DESTDIR}/usr/share/guadalinex-noodle
	rm -f ${DESTDIR}/etc/xdg/autostart/vdccm.desktop
	rm -f ${DESTDIT}/etc/ppp/peers/dun
