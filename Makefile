CFGDIR  = $(DESTDIR)/etc
HOOKDIR = $(DESTDIR)/usr/share/libalpm/hooks
BINDIR  = $(DESTDIR)/opt/pug

.PHONY: install
install:
	@mkdir -p $(CFGDIR)
	@mkdir -p $(HOOKDIR)
	@mkdir -p $(BINDIR)
	@mkdir -p $(DESTDIR)/root
	@chmod 750 $(DESTDIR)/root
	@touch $(CFGDIR)/pug
	@if test -r /etc/pug.bkp; then cat /etc/pug.bkp > $(CFGDIR)/pug; fi
	@chmod 644 $(CFGDIR)/pug
	@cp src/pug.sh $(BINDIR)
	@chmod 755 $(BINDIR)/pug.sh
	@sh $(BINDIR)/pug.sh $(DESTDIR)
	@cp src/pug.hook $(HOOKDIR)
	@chmod 644 $(HOOKDIR)/pug.hook

.PHONY: uninstall
uninstall:
	$(RM) $(CFGDIR)/pug
	$(RM) $(HOOKDIR)/pug.hook
	$(RM) $(DESTDIR)/root/.gist
	$(RM) $(BINDIR)/pug.sh

.PHONY: distclean
distclean: uninstall
	$(RM) $(CFGDIR)/pug.bkp
	$(RM) $(DESTDIR)/root/.gist.bkp
