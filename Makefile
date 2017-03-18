CFGDIR  = $(DESTDIR)/etc
HOOKDIR = $(DESTDIR)/usr/share/libalpm/hooks
BINDIR  = $(DESTDIR)/opt/pug

CFG     = pug
HOOK    = src/pug.hook
SCRIPT  = src/pug.sh

INSTALLGIST  := 1

install:
	@mkdir -p $(CFGDIR)
	@mkdir -p $(HOOKDIR)
	@mkdir -p $(BINDIR)
	@touch $(CFGDIR)/$(CFG)
	@chmod 644 $(CFGDIR)/$(shell basename $(CFG))
	@cp $(SCRIPT) $(BINDIR)
	@chmod 755 $(BINDIR)/$(shell basename $(SCRIPT))
	@if test "$(INSTALLGIST)" = "1" ; then \
		. $(BINDIR)/$(shell basename $(SCRIPT)); \
		pug_install "$(DESTDIR)"; \
	fi
	@cp $(HOOK) $(HOOKDIR)
	@chmod 644 $(HOOKDIR)/$(shell basename $(HOOK))

uninstall:
	$(RM) $(CFGDIR)/$(shell basename $(CFG))
	$(RM) $(HOOKDIR)/$(shell basename $(HOOK))
	$(RM) -r $(BINDIR)
	$(RM) /root/.gist

.PHONY: install uninstall
