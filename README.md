Pug
===

[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/Ventto/xpub/blob/master/LICENSE)
[![Language (Bash)](https://img.shields.io/badge/powered_by-Gist-brightgreen.svg)](https://github.com/defunkt/gist)

*"Pug is a post-transaction hook to save installed Pacman & AUR package lists into Gist files."*

## Perks

* [x] **Painless**: do not care about remembering installed packages on your system.
* [x] **Triggers**: install/remove a package and system upgrade.
* [x] **Usefull**: Gists used for quick install on another system.
* [x] **Elegant**: Same terminal output template and colors than Pacman.

## Requirements

* *pacman* - A library-based package manager with dependency support
* *gist* - Potentially the best command line gister

## Install

```bash
$ git clone https://github.com/Ventto/pug.git
$ cd pug
$ sudo make install    (default: INSTALLGIST=1)
```



## Example

* Post-package-install trigger:
```
:: Proceed with installation? [Y/n] Y
(1/1) checking keys in keyring        [##########] 100%
[...]
(1/1) checking available disk space   [##########] 100%
:: Processing package changes...
(1/1) installing package              [##########] 100%
:: Running post-transaction hooks...
(1/2) pug.hook
:: Processing gists update...
```

## FAQ

### Gist for quick install

The purpose of using Gist files is to quickly install your preferred packages on another system.

* Quick install Pacman package list:

```bash
wget https://gist.githubusercontent.com/.../pacman-list.pkg
pacman -S - < pacman-list.txt
```

* Quick install AUR package list:

```bash
wget https://gist.githubusercontent.com/.../aur-list.pkg
pacaur -S - < aur-list.txt
```

### Change Gist filenames

Take a look at the sources into `src/pug.sh` or after installation into `/usr/lib/pug/pug.sh`.

