CFGDIR  = $(DESTDIR)/etc
HOOKDIR = $(DESTDIR)/usr/share/libalpm/hooks
BINDIR  = $(DESTDIR)/usr/lib/pug

CFG		= pug
HOOK	= src/pug.hook
SCRIPT	= src/pug.sh

all:

install:
	@mkdir -p $(CFGDIR)
	@mkdir -p $(HOOKDIR)
	@mkdir -p $(BINDIR)
	@touch $(CFGDIR)/$(CFG)
	@chmod 644 $(CFGDIR)/$(shell basename $(CFG))
	@cp $(SCRIPT) $(BINDIR)
	@chmod 755 $(BINDIR)/$(shell basename $(SCRIPT))
	@source $(BINDIR)/$(shell basename $(SCRIPT)); pug_install "$(DESTDIR)";
	@cp $(HOOK) $(HOOKDIR)
	@chmod 644 $(HOOKDIR)/$(shell basename $(HOOK))

uninstall:
	$(RM) $(CFGDIR)/$(shell basename $(CFG))
	$(RM) $(HOOKDIR)/$(shell basename $(HOOK))
	$(RM) -r $(BINDIR)

.PHONY: all install uninstall
