#!/bin/bash

bacpac_install() {
    [ -n "${1}" ] && [ ! -d "${1}" ] && exit 1

    pkgdir="${1}"

    if ! gist --login ; then exit 1; fi

    mkdir -p "${pkgdir}/root";
    cp ~/.gist "${pkgdir}/root/.gist";

    echo "1: Creating installed packages lists.";

    GIST_NAT=$(pacman -Qqen | gist -p -f native-list.pkg)
    GIST_AUR=$(pacman -Qqem | gist -p -f aur-list.pkg)

    echo "2: Gist links:"
    echo -e "GIST_NAT=${GIST_NAT}\nGIST_AUR=${GIST_AUR}" | \
        sed 's/https:\/\/gist.github.com\///g' >> "${pkgdir}/etc/bacpac";
    echo -e "${GIST_NAT}\n${GIST_AUR}"
}

bacpac_update() {
    echo 'bacpac: updating package list...';
    if ! pacman -Qqen | gist -u "${GIST_NAT}" -f native-list.pkg ; then exit 1; fi
    if ! pacman -Qqem | gist -u "${GIST_AUR}" -f aur-list.pkg;     then exit 1; fi
}

bacpac() {
    # Add Ruby to PATH
    PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"

    # Load config
    [[ -r '/etc/bacpac' ]] && source "${pkgdir}/etc/bacpac"

    # Determine if fresh install is needed
    if [ -z "${GIST_NAT}" ] || [ -z "${GIST_AUR}" ]; then
        echo "bacpac: fresh install detected."
    else
        bacpac_update;
    fi
}

bacpac "$@"
