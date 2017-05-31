#!/bin/sh

normal="$(tput sgr0)"
bold="$(tput bold)"
red="$(tput setaf 1)"
green="$(tput setaf 2)"
cyan="$(tput setaf 6)"
white="$(tput setaf 7)"

PACMANFILE='pacman-list.pkg'
AURFILE='aur-list.pkg'

pug_install() {
    echo "${bold}${green}==>${white} Authentification on Github..."

    ! gist --login && exit 1

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

    # Force backup if updating pug
    if test -f /etc/pug; then
        cp /etc/pug /etc/pug.bkp
    else
        if test -f /etc/pug.bkp; then
            cp /etc/pug.bkp /etc/pug
        else
            echo "${bold}${red}::${white}/etc/pug: gist IDs file not found.${normal}"
            echo "${bold}${red}::${white}/etc/pug.bkp: backup file not found.${normal}"
            exit 1
        fi
    fi
    if test -f /root/.gist; then
        cp /root/.gist /root/.gist.bkp
    else
        if test -f /root/.gist.bkp; then
            cp /root/.gist.bkp /root/.gist
        else
            echo "${bold}${red}::${white}/root/.gist: token file not found.${normal}"
            echo "${bold}${red}::${white}/root/.gist.bkp: backup file not found.${normal}"
            exit 1
        fi
    fi

    if ! gist -r "${GIST_NAT}" > /tmp/pacman.gist; then
        echo "${bold}${red}::${white} Failed to read gist.${normal}"
        exit 1
    fi

    pacman -Qqen > /tmp/pacman.list
    if ! diff /tmp/pacman.gist /tmp/pacman.list > /dev/null 2>&1; then
        if ! cat /tmp/pacman.list | gist -u "${GIST_NAT}" -f "${PACMANFILE}"; then
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
        if ! cat /tmp/aur.list | gist -u "${GIST_AUR}" -f "${AURFILE}"; then
            echo "${bold}${red}::${white} Failed to update.${normal}"
            exit 1
        fi
    fi
}

pug() {
    PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"

    if [ -n "${1}" ] && [ ! -d "${1}" ]; then
        echo "${bold}${red}:: ${white}${1}: package directory not found.${normal}"
        exit 1
    fi

    pkgdir="${1}"

    test -r ${pkgdir}/etc/pug && . ${pkgdir}/etc/pug

    # Determine if fresh install is needed
    if test -z "${GIST_NAT}" || test -z "${GIST_AUR}"; then
        echo "${bold}${cyan}::${white} Pug: fresh install is needed.${normal}"
        pug_install "${pkgdir}"
    else
        IS_FAKEROOT=false
        if echo "${LD_LIBRARY_PATH}" | grep libfakeroot > /dev/null; then
            IS_FAKEROOT=true
        fi
        if [ "$(id -u)" -eq 0 ] && ! ${IS_FAKEROOT}; then
            pug_update
        fi
    fi
}

pug "$@"
