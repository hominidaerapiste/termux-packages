TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="Qt port of volume control of sound server PulseAudio"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION="1.1.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/pavucontrol-qt/releases/download/${TERMUX_PKG_VERSION}/pavucontrol-qt-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=1b84af1ab958c1de3521296faad94b06425416fbc735b5e5af2cbcca8aa07878
TERMUX_PKG_DEPENDS="qt5-qtbase, kwindowsystem, liblxqt, pulseaudio-glib"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true
