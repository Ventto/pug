Pug
===

[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/Ventto/xpub/blob/master/LICENSE)
[![Tools (Gist)](https://img.shields.io/badge/powered_by-Gist-brightgreen.svg)](https://github.com/defunkt/gist)

*"Pug is a post-transaction hook to automatically save installed Pacman & AUR package lists into Gist files."*

Inspired by [*plist-gist*](https://github.com/DerekTBrown/plist-gist) and [*pacmanity*](https://github.com/alexchernokun/pacmanity).

## Perks

* [x] **Painless**: do not care about remembering installed packages on your system.
* [x] **Triggers**: install/remove a package and system upgrade.
* [x] **Elegant**: as built-in, uses Pacman's term-output template and colors.
* [x] **Extra**: Gists used for quick install on another system.

## Requirements

* *pacman* - A library-based package manager with dependency support
* *gist* - Potentially the best command line gister

# Installation

### Package (AUR)

```bash
$ pacaur -S pug
```

### Manually

```bash
$ git clone https://github.com/Ventto/pug.git
$ cd pug
$ sudo make install (default: INSTALLGIST=1, gists creation)
```

### Uninstall

```bash
$ sudo make uninstall
```

# Screenshots

![Gist revisions](doc/revisions.jpg)

# FAQ

## Gist for quick install

The purpose of using Gist files is to quickly install your preferred packages on another system.

* Quick install the Pacman package list:

```bash
$ wget https://gist.githubusercontent.com/.../pacman-list.pkg
$ pacman -S - < pacman-list.txt
```

* Quick install the AUR package list:

```bash
$ wget https://gist.githubusercontent.com/.../aur-list.pkg
$ pacaur -S - < aur-list.txt
```

## Change Gist filenames

Take a look at the sources into `src/pug.sh` or after installation into `/opt/pug/pug.sh`.

# TODO

* [ ] Pre-install, selecting package-list-Gists to generate (pacman or aur or both).
* [ ] Once triggered, you can choice to do not apply change on Gists.
* [ ] Avoiding a Gist revision if there is no modification in the package list.

