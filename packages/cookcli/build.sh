TERMUX_PKG_HOMEPAGE=https://cooklang.org
TERMUX_PKG_DESCRIPTION="A suite of tools to create shopping lists and maintain food recipes"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.7.1"
TERMUX_PKG_SRCURL=https://github.com/cooklang/cookcli/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=01d7add669aeb3059e2997cb6108715751ba82d4acc97d04f0d3d8bef0e08a46
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_nodejs
	termux_setup_rust

	# i686: __atomic_load
	if [[ "${TERMUX_ARCH}" == "i686" ]]; then
		RUSTFLAGS+=" -C link-arg=$(${CC} -print-libgcc-file-name)"
	fi
}

termux_step_make() {
	pushd ui
	npm install
	npm run build
	popd

	cargo build --jobs "${TERMUX_MAKE_PROCESSES}" --target "${CARGO_TARGET_NAME}" --release
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}/bin" "target/${CARGO_TARGET_NAME}/release/cook"
}
