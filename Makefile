PREFIX = /usr/local

default:

.PHONY: install uninstall test

install:
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp filter-other-days $(DESTDIR)$(PREFIX)/bin/filter-other-days
	chmod 0755 $(DESTDIR)$(PREFIX)/bin/filter-other-days
	mkdir -p $(DESTDIR)$(PREFIX)/share/man/man1
	gzip -c filter-other-days.1 > $(DESTDIR)$(PREFIX)/share/man/man1/filter-other-days.1.gz
	chmod 0644 $(DESTDIR)$(PREFIX)/share/man/man1/filter-other-days.1.gz

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/filter-other-days
	rm -f $(DESTDIR)$(PREFIX)/share/man/man1/filter-other-days.1.gz

test:
	./test/run-tests.sh
