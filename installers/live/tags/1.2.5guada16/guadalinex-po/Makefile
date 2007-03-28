# List here all source files with translatable strings.
POTFILES=../ubiquity/frontend/gtkui.py

POFILES=$(wildcard *.po)
MOFILES=$(POFILES:.po=.mo)

all: guadalinex-installer.pot $(MOFILES)

install: all
	for file in $(MOFILES); do \
		lang=`echo $$file | sed 's/\.mo//'`; \
		mkdir -p $(prefix)/usr/share/locale/$$lang/LC_MESSAGES/; \
		install -d $(prefix)/usr/share/locale/$$lang/LC_MESSAGES/; \
		install -m 0644 $$file $(prefix)/usr/share/locale/$$lang/LC_MESSAGES/guadalinex-installer.mo; \
	done

guadalinex-installer.pot: $(POTFILES)
# xgettext can mostly handle perl files as C files, though it gets a bit
# confused about single quotes in comments, and the gettext() calls have to
# use double-quoted strings or it will ignore them.
	@echo "Rebuilding the pot file"
	xgettext $(POTFILES) -o guadalinex-installer.pot -Lpython

clean:
	rm -f guadalinex-installer.pot $(MOFILES) messages messages.mo

%.mo: %.po
	msgfmt -o $@ $<

%.po: guadalinex-installer.pot
	@echo -n "Merging guadalinex-installer.pot and $@"
	@msgmerge $@ guadalinex-installer.pot -o $@.new
# Typically all that changes was a date. I'd prefer not to cvs commit such
# changes, so detect and ignore them.
	@if [ "`diff $@ $@.new | grep '[<>]' | wc -l`" -ne 2 ]; then \
		mv -f $@.new $@; \
	else \
		rm -f $@.new; \
	fi
	@msgfmt --statistics $@

check:
	@for file in $(POFILES); do \
		lang=`echo $$file | sed 's/\.po//'`; \
		printf "$$lang: "; \
		msgfmt -o /dev/null -c -v --statistics $$lang.po;\
	done
