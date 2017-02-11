#!/bin/bash

bacpac_install() {
    if ! gist --login ; then
        exit 1
    fi

    mkdir -p "${pkgdir}/root";
    cp ~/.gist "${pkgdir}/root/.gist";

    echo "1: Creating installed packages lists.";

    GIST_URL_NAT=$(pacman -Qqen | \
        gist -p -f 'arch-pkg.native' -d "install: Added native packages.")

    GIST_URL_AUR=$(pacman -Qqem | \
        gist -p -f 'arch-pkg.aur' -d "install: Added aur packages.")

    echo "2: Gist links:"
    echo "GIST_NAT=${GIST_URL_NAT}" | \
        sed 's/https:\/\/gist.github.com\///g' >> "${pkgdir}/etc/bacpac";
    echo "GIST_AUR=${GIST_URL_AUR}" | \
        sed 's/https:\/\/gist.github.com\///g' >> "${pkgdir}/etc/bacpac";
    echo "${GIST_URL_NAT}"
    echo "${GIST_URL_AUR}"
}

bacpac_update() {

    echo 'bacpac: updating package list...';

    if pacman -Qqen | gist -u "${GIST_NAT}"; then
        echo 'bacpac: native - [OK]';
    else
        exit 1;
    fi

    if pacman -Qqem | gist -u "${GIST_AUR}"; then
        echo -n 'bacpac: aur - [OK]';
    else
        exit 1;
    fi
}

bacpac() {

    # Add Ruby to PATH
    PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"

    # Load config
    [[ -r '/etc/bacpac' ]] && source "$pkgdir/etc/bacpac"

    # Determine if fresh install is needed
    if [ -z "${GIST_NAT}" ] || [ -z "${GIST_AUR}" ]; then
        echo "bacpac: fresh install detected."
    else
        bacpac_update;
    fi
}

bacpac "$@"
