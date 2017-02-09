#!/bin/bash

bacpac_install(){

    gist --login;
	mkdir -p $pkgdir/root;
	cp ~/.gist $pkgdir/root/.gist;

	echo "2: Creating installed packages lists.";

	local filenat="arch-pkg.native"
	local fileaur="arch-pkg.aur"

	GIST_URL_NAT=$(pacman -Qqen | \
		gist -p -f "${filenat}" -d "install: Added native packages.")
	GIST_URL_AUR=$(pacman -Qqem | \
		gist -p -f "${fileaur}" -d "install: Added aur packages.")

	echo "3: Gist links:"
	echo "GIST_NAT=$GIST_URL_NAT" | \
		sed 's/https:\/\/gist.github.com\///g' >> $pkgdir/etc/bacpac;
	echo "GIST_AUR=$GIST_URLèAUR" | \
		sed 's/https:\/\/gist.github.com\///g' >> $pkgdir/etc/bacpac;
	echo "$filenat: $GIST_NAT"
	echo "$fileaur: $GIST_AUR"
}

bacpac_update(){

	echo -e "\nUpdating package list backup on GitHub...";

	if pacman -Qqen | gist -u "$GIST_ID"; then
		echo -e "bacpac: native - [OK]\n";
	else
		echo -e "bacpac: native - [FAILED]\n";
	fi

	if pacman -Qqem | gist -u "$GIST_ID"; then
		echo -e "bacpac: aur - [OK]\n";
	else
		echo -e "bacpac: aur - [FAILED]\n";
	fi


}

bacpac(){
	# Add Ruby to PATH
	PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"

	# Load config
	[[ -r '/etc/bacpac' ]] && source $pkgdir/etc/bacpac

	echo "Bacpac:"

	# Determine if fresh install is needed
	if [ -z "$GIST_NAT" ] || [ -z "$GIST_AUR" ]; then
		echo "1: Fresh install detected."
	else
		update;
	fi
}

bacpac "$@"
