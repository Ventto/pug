Plist
===

![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)

Store your Pacman & AUR package lists in Gist files. 
Based on [pug](https://github.com/Ventto/pug).

## Features

* [x] **Painless**: Backup and easily restore package lists
* [x] **Elegant**: Same text coloration than *pacman*
* [x] **Smart**: Gist revision after each command if change

## Requirements

* pacman
* gist

## Installation

The install process will ask your Github login to create Gist files and
generate an OAuth2 access token.<br/>
*plist* uses that token to update your Gists as needed.

### Package (AUR)

```bash
$ (AUR Helper) -S plist
```

### Manually

```bash
git clone https://github.com/jmdaemon/plist.git
cd plist
sudo make install (default: INSTALLGIST=1, gists creation)
```

* To uninstall:
``` bash
sudo make uninstall
```

## Restore

Quickly install the package lists from Gists.

* Install Pacman package list:

```bash
wget -O pacman-list.pkg [URL]
pacman -S - < pacman-list.pkg
```

* Install AUR package list:

```bash
wget -O aur-list.pkg [URL]
xargs <aur-list.pkg (AUR Helper) -S --noedit
```
