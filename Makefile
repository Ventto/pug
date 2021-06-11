CFGDIR  = $(DESTDIR)/etc
HOOKDIR = $(DESTDIR)/usr/share/libalpm/hooks
BINDIR  = $(DESTDIR)/opt/plist

.PHONY: install
install:
	@mkdir -p $(CFGDIR)
	@mkdir -p $(HOOKDIR)
	@mkdir -p $(BINDIR)
	@mkdir -p $(DESTDIR)/root
	@chmod 750 $(DESTDIR)/root
	@touch $(CFGDIR)/plist
	@if test -r /etc/plist.bkp; then cat /etc/plist.bkp > $(CFGDIR)/plist; fi
	@chmod 644 $(CFGDIR)/plist
	@cp src/plist.sh $(BINDIR)
	@chmod 755 $(BINDIR)/plist.sh
	@sh $(BINDIR)/plist.sh $(DESTDIR)
	@cp src/plist.hook $(HOOKDIR)
	@chmod 644 $(HOOKDIR)/plist.hook

.PHONY: uninstall
uninstall:
	$(RM) $(CFGDIR)/plist
	$(RM) $(HOOKDIR)/plist.hook
	$(RM) $(DESTDIR)/root/.gist
	$(RM) $(BINDIR)/plist.sh

.PHONY: distclean
distclean: uninstall
	$(RM) $(CFGDIR)/plist.bkp
	$(RM) $(DESTDIR)/root/.gist.bkp
