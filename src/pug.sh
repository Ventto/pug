#!/bin/sh

normal="$(tput sgr0)"
bold="$(tput bold)"
green="$(tput setaf 2)"
cyan="$(tput setaf 6)"
white="$(tput setaf 7)"

PACMANFILE='pacman-list.pkg'
AURFILE='aur-list.pkg'

pug_install() {
    if [ -n "${1}" ] && [ ! -d "${1}" ]; then
        echo "${1}: package directory not found."
        exit 1
    fi

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
        sed 's/https:\/\/gist.github.com\///g' > "${pkgdir}/etc/pug";
    echo "GIST_AUR=${GIST_AUR}" | \
        sed 's/https:\/\/gist.github.com\///g' >> "${pkgdir}/etc/pug";

    echo "    [ ${cyan}${GIST_NAT}${white} ]"
    echo "    [ ${cyan}${GIST_AUR}${white} ]"
}

pug_update() {
    echo "${bold}${cyan}::${white} Processing gists update...${normal}"

    if ! gist -r "${GIST_NAT}" > /tmp/pacman.gist; then
        echo "${bold}${red}::${white} Failed to read gist.${normal}"
        exit 1
    fi

    pacman -Qqen > /tmp/pacman.list
    if ! diff /tmp/pacman.gist /tmp/pacman.list > /dev/null 2>&1; then
        if ! pacman -Qqen | gist -u "${GIST_NAT}" -f "${PACMANFILE}"; then
            echo "${bold}${red}::${white} Failed to update.${normal}"
            exit 1
        fi
    fi

    if ! gist -r "${GIST_AUR}" > /tmp/aur.gist; then
        echo "${bold}${red}::${white} Failed to read gist.${normal}"
        exit 1
    fi

    pacman -Qqem > /tmp/aur.list
    if ! diff /tmp/aur.gist /tmp/aur.list > /dev/null 2>&1; then
        if ! pacman -Qqem | gist -u "${GIST_AUR}" -f "${AURFILE}"; then
            echo "${bold}${red}::${white} Failed to update.${normal}"
            exit 1
        fi
    fi
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
