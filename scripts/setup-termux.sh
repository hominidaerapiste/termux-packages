#!/bin/bash

PACKAGES=""
# Tier 1: requirements for the core build scripts in scripts/build/.
PACKAGES+=" clang"				# Required for termux-elf-cleaner and C/C++ packages.
PACKAGES+=" file"				# Used in termux_step_massage().
PACKAGES+=" gnupg"				# Used in termux_get_repo_files() and build-package.sh.
PACKAGES+=" lzip"				# Used by tar to extract *.tar.lz source archives.
PACKAGES+=" patch"				# Used for applying patches on source code.
PACKAGES+=" python"				# Used buildorder.py core script.
PACKAGES+=" unzip"				# Used to extract *.zip source archives.
PACKAGES+=" jq"					# Used for parsing repo.json.
PACKAGES+=" binutils-is-llvm"			# Used for checking symbols.

# Tier 2: requirements for building many other packages.
PACKAGES+=" asciidoc"
PACKAGES+=" asciidoctor"
PACKAGES+=" autoconf"
PACKAGES+=" automake"
PACKAGES+=" bc"
PACKAGES+=" byacc"
PACKAGES+=" bsdtar"                     # Needed to create pacman packages
PACKAGES+=" cmake"
PACKAGES+=" ed"
PACKAGES+=" flex"
PACKAGES+=" gettext"
PACKAGES+=" git"
PACKAGES+=" golang"
PACKAGES+=" gperf"
PACKAGES+=" help2man"
PACKAGES+=" libtool"
PACKAGES+=" m4"
PACKAGES+=" make"			# Used for all Makefile-based projects.
PACKAGES+=" ninja"			# Used by default to build all CMake projects.
PACKAGES+=" perl"
PACKAGES+=" pkg-config"
PACKAGES+=" protobuf"
PACKAGES+=" python2"
PACKAGES+=" re2c"                       # Needed by kphp-timelib
PACKAGES+=" rust"
PACKAGES+=" scdoc"
PACKAGES+=" texinfo"
PACKAGES+=" uuid-utils"
PACKAGES+=" valac"
PACKAGES+=" xmlto"                      # Needed by git's manpage generation
PACKAGES+=" zip"

# Tier 3: requirements for community repos.
PACKAGES+=" tur-repo x11-repo"
PACKAGES+=" ndk-multilib-native-stubs"

# FIXME: WTF is this for?
# echo "" >> /system/etc/static-dns-hosts.txt
# echo "# Community TUR Repo" >> /system/etc/static-dns-hosts.txt
# echo "tur.kcubeterm.com" >> /system/etc/static-dns-hosts.txt
# echo "turdl.kcubeterm.com" >> /system/etc/static-dns-hosts.txt
# echo "termux-user-repository.github.io"  >> /system/etc/static-dns-hosts.txt
# echo "crates.io"  >> /system/etc/static-dns-hosts.txt
# echo "static.crates.io"  >> /system/etc/static-dns-hosts.txt
# echo "index.crates.io"  >> /system/etc/static-dns-hosts.txt

# Definition of a package manager
export TERMUX_SCRIPTDIR=$(dirname "$(realpath "$0")")/../
. $(dirname "$(realpath "$0")")/properties.sh
source "$TERMUX_PREFIX/bin/termux-setup-package-manager" || true

update-static-dns

if [ "$TERMUX_APP_PACKAGE_MANAGER" = "apt" ]; then
	sed -i "s/packages.termux.dev/packages-cf.termux.dev/g" /data/data/com.termux/files/usr/etc/apt/sources.list
	apt update
	apt dist-upgrade -o Dpkg::Options::=--force-confnew -y
	sed -i "s/packages.termux.dev/packages-cf.termux.dev/g" /data/data/com.termux/files/usr/etc/apt/sources.list
	apt update
	apt dist-upgrade -y
	apt install -y $PACKAGES
elif [ "$TERMUX_APP_PACKAGE_MANAGER" = "pacman" ]; then
	pacman -Syu $PACKAGES --needed --noconfirm
else
	echo "Error: no package manager defined"
	exit 1
fi
