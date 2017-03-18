#!/usr/bin/env bash

normal="$(tput sgr0)"
bold="$(tput bold)"
green="$(tput setaf 2)"
cyan="$(tput setaf 6)"
white="$(tput setaf 7)"

PACMANFILE='pacman-list.pkg'
AURFILE='aur-list.pkg'

pug_install() {
    [ -n "${1}" ] && [ ! -d "${1}" ] && exit 1

    pkgdir="${1}"

    echo "${bold}${green}==>${white} Authentification on Github..."

    if ! gist --login ; then exit 1; fi

    mkdir -p "${pkgdir}/root";

    if ! cmp --silent ~/.gist "${pkgdir}/root/.gist"; then
        cp ~/.gist "${pkgdir}/root/.gist";
    fi

    echo "${bold}${green}==>${white} Saving installed package lists to gists..."
    echo "${bold}${cyan}  ->${white} Creating packages lists..."
    echo "${bold}${cyan}  ->${white} Generating gist links..."

    GIST_NAT=$(pacman -Qqen | gist -p -f "${PACMANFILE}" -d 'Pacman package list.')
    GIST_AUR=$(pacman -Qqem | gist -p -f "${AURFILE}" -d 'AUR package list.')

    echo "GIST_NAT=${GIST_NAT}" | \
        sed 's/https:\/\/gist.github.com\///g' >> "${pkgdir}/etc/pug";
    echo "GIST_AUR=${GIST_AUR}" | \
        sed 's/https:\/\/gist.github.com\///g' >> "${pkgdir}/etc/pug";

    echo "    [ ${cyan}${GIST_NAT}${white} ]"
    echo "    [ ${cyan}${GIST_AUR}${white} ]"
}

pug_update() {
    echo "${bold}${cyan}::${white} Processing gists update...${normal}"

    if ! pacman -Qqen | gist -u "${GIST_NAT}" -f "${PACMANFILE}"; then exit 1; fi
    if ! pacman -Qqem | gist -u "${GIST_AUR}" -f "${AURFILE}";    then exit 1; fi
}

pug() {
    PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"

    test -r '/etc/pug' && . "${pkgdir}/etc/pug"

    # Determine if fresh install is needed
    if test -z "${GIST_NAT}" || test -z "${GIST_AUR}"; then
        echo "${bold}${cyan}::${white} Pug: fresh install is needed.${normal}"
    else
        pug_update;
    fi
}

pug "$@"
