#!/bin/bash

if test -t 1; then
    ncolors=$(tput colors)
    if test -n "$ncolors"; then
        normal="$(tput sgr0)"
        bold="$(tput bold)"
        green="$(tput setaf 2)"
        cyan="$(tput setaf 6)"
        white="$(tput setaf 7)"
    fi
fi

bacpac_install() {
    [ -n "${1}" ] && [ ! -d "${1}" ] && exit 1

    pkgdir="${1}"

    if ! gist --login ; then exit 1; fi

    mkdir -p "${pkgdir}/root";

    if ! cmp --silent ~/.gist "${pkgdir}/root/.gist"; then
        cp ~/.gist "${pkgdir}/root/.gist";
    fi

    echo
    echo "${bold}${green}==>${white} Saving installed package lists to gists..."
    echo "${bold}${cyan}  ->${white} Creating packages lists..."
    echo "${bold}${cyan}  ->${white} Generating gist links..."

    GIST_NAT=$(pacman -Qqen | gist -p -f native-list.pkg)
    GIST_AUR=$(pacman -Qqem | gist -p -f aur-list.pkg)

    echo "GIST_NAT=${GIST_NAT}" | \
        sed 's/https:\/\/gist.github.com\///g' >> "${pkgdir}/etc/bacpac";
    echo "GIST_AUR=${GIST_AUR}" | \
        sed 's/https:\/\/gist.github.com\///g' >> "${pkgdir}/etc/bacpac";
    echo "    ${GIST_NAT}"
    echo "    ${GIST_AUR}"
    echo
}

bacpac_update() {
    echo "${bold}[bacpac]"
    echo "${bold}${cyan}:: ${white} Updating package list gists...${normal}"

    if ! pacman -Qqen | gist -u "${GIST_NAT}" -f native-list.pkg ; then exit 1; fi
    if ! pacman -Qqem | gist -u "${GIST_AUR}" -f aur-list.pkg;     then exit 1; fi
}

bacpac() {
    PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"

    test -r '/etc/bacpac' && source "${pkgdir}/etc/bacpac"

    # Determine if fresh install is needed
    if test -z "${GIST_NAT}" || test -z "${GIST_AUR}"; then
        echo "${bold}[bacpac]"
        echo "${cyan}:: ${white}Fresh install is needed.${normal}"
        echo
    else
        bacpac_update;
    fi
}

bacpac "$@"
