Pug
===

[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/Ventto/xpub/blob/master/LICENSE)
[![Tools (Gist)](https://img.shields.io/badge/powered_by-Gist-brightgreen.svg)](https://github.com/defunkt/gist)
[![Vote for pug](https://img.shields.io/badge/AUR-Vote_for-yellow.svg)](https://aur.archlinux.org/packages/pug/)

*"Pug is a ALPM-hook to automatically save installed Pacman & AUR package lists into Gist files."*

Inspired by [*plist-gist*](https://github.com/DerekTBrown/plist-gist) and [*pacmanity*](https://github.com/alexchernokun/pacmanity).

## Perks

* [x] **Painless**: Backup and easily restore package lists
* [x] **Elegant**: Same text coloration than *pacman*
* [x] **Smart**: Gist revision after each command if change

![Gist revisions](doc/revisions.jpg)

## Requirements

* *pacman* - A library-based package manager with dependency support
* *gist* - Potentially the best command line gister

# Installation

The install process will ask your Github login to create Gist files and
generate an OAuth2 access token.<br/>
*pug* uses that token to update your Gists as needed.

### Stable release package (AUR)

```bash
$ pacaur -S pug
```

### Git package (AUR)

```bash
$ pacaur -S pug-hook-git
```

### Manually

```bash
$ git clone https://github.com/Ventto/pug.git
$ cd pug
$ sudo make install (default: INSTALLGIST=1, gists creation)
# Or Uninstall
$ sudo make uninstall
```

# Restore

Quickly install the package lists from Gists.

* Install Pacman package list:

```bash
$ wget -O pacman-list.pkg [URL]
$ pacman -S - < pacman-list.pkg
```

* Install AUR packag list:

```bash
$ wget -O aur-list.pkg [URL]
$ xargs <aur-list.pkg pacaur -S --noedit
```
