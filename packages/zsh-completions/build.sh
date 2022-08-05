TERMUX_PKG_HOMEPAGE=https://github.com/zsh-users/zsh-completions
TERMUX_PKG_DESCRIPTION="Additional completion definitions for Zsh"
TERMUX_PKG_LICENSE=custom
TERMUX_PKG_LICENSE_FILE=LICENSE
TERMUX_PKG_MAINTAINER=@termux
TERMUX_PKG_VERSION="0.34.0"
TERMUX_PKG_SRCURL=$TERMUX_PKG_HOMEPAGE/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=21b6c194b15ae3992f4c2340ab249aa326a9874d46e3130bb3f292142c217fe2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS=zsh
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	install -Dm644 src/* -t "$TERMUX_PREFIX/share/zsh/site-functions"
}

