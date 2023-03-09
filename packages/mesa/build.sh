TERMUX_PKG_HOMEPAGE=https://www.mesa3d.org
TERMUX_PKG_DESCRIPTION="An open-source implementation of the OpenGL specification"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="docs/license.rst"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=23.0.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://archive.mesa3d.org/mesa-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=1b7d3399fc6f16f030361f925d33ebc7600cbf98094582f54775b6a1180529e7
TERMUX_PKG_DEPENDS="libandroid-shmem, libc++, libdrm, libexpat, libglvnd, libwayland, libx11, libxext, libxfixes, libxshmfence, libxxf86vm, ncurses, zlib, zstd, glslang, libvdpau, valgrind, libva, libomxil-bellagio, libelf, vulkan-loader-generic"
TERMUX_PKG_SUGGESTS="mesa-dev"
TERMUX_PKG_BUILD_DEPENDS="libllvm-static, libwayland-protocols, libxrandr, llvm, llvm-tools, mlir, xorgproto, rust"
TERMUX_PKG_CONFLICTS="libmesa, ndk-sysroot (<= 25b)"
TERMUX_PKG_REPLACES="libmesa"
TERMUX_PKG_PYTHON_COMMON_DEPS="mako"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--cmake-prefix-path $TERMUX_PREFIX
-Dcpp_rtti=false
-Dgbm=enabled
-Dopengl=true
-Degl=enabled
-Degl-native-platform=x11
-Dgles1=disabled
-Dgles2=enabled
-Ddri3=enabled
-Dglx=dri
-Dllvm=enabled
-Dshared-llvm=disabled
-Dplatforms=x11,wayland
-Dgallium-drivers=r300,r600,radeonsi,freedreno,nouveau,swrast,virgl,zink,d3d12,etnaviv,kmsro,lima,panfrost,v3d,vc4,asahi,svga,tegra
-Dgallium-extra-hud=true
-Dgallium-nine=true
-Dgallium-omx=bellagio
-Dgallium-va=enabled
-Dgallium-vdpau=enabled
-Dgallium-xa=enabled
-Dvulkan-drivers=amd,swrast,broadcom,panfrost,virtio-experimental
-Dvulkan-layers=overlay
-Dosmesa=true
-Dglvnd=true
-Dxmlconfig=disabled
-Dvalgrind=enabled
-Dshared-glapi=enabled
-Dmicrosoft-clc=disabled
-Db_ndebug=true
-Dgallium-rusticl=true
-Drust_std=2021
"

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_rust
	termux_setup_cargo_c
	termux_setup_glslang

	CFLAGS+=' -g1'
	CXXFLAGS+=' -g1'

	CPPFLAGS+=" -D__USE_GNU -fno-rtti"
	LDFLAGS+=" -landroid-shmem -lexpat"

	_WRAPPER_BIN=$TERMUX_PKG_BUILDDIR/_wrapper/bin
	mkdir -p $_WRAPPER_BIN
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		sed 's|@CMAKE@|'"$(command -v cmake)"'|g' \
			$TERMUX_PKG_BUILDER_DIR/cmake-wrapper.in \
			> $_WRAPPER_BIN/cmake
		chmod 0700 $_WRAPPER_BIN/cmake
		sed "s|^export PKG_CONFIG_LIBDIR=|export PKG_CONFIG_LIBDIR=${TERMUX_PREFIX}/opt/libwayland/cross/lib/x86_64-linux-gnu/pkgconfig:|" \
			"${TERMUX_STANDALONE_TOOLCHAIN}/bin/pkg-config" \
			> "${_WRAPPER_BIN}/pkg-config"
		chmod +x "${_WRAPPER_BIN}/pkg-config"
		export PKG_CONFIG="${_WRAPPER_BIN}/pkg-config"
	fi
	export PATH=$_WRAPPER_BIN:$PATH
}

termux_step_post_configure() {
	rm -f $_WRAPPER_BIN/cmake
}

termux_step_post_make_install() {
	# Avoid hard links
	local f1
	for f1 in $TERMUX_PREFIX/lib/dri/*; do
		if [ ! -f "${f1}" ]; then
			continue
		fi
		local f2
		for f2 in $TERMUX_PREFIX/lib/dri/*; do
			if [ -f "${f2}" ] && [ "${f1}" != "${f2}" ]; then
				local s1=$(stat -c "%i" "${f1}")
				local s2=$(stat -c "%i" "${f2}")
				if [ "${s1}" = "${s2}" ]; then
					ln -sfr "${f1}" "${f2}"
				fi
			fi
		done
	done

	# Create symlinks
	ln -sf libEGL_mesa.so ${TERMUX_PREFIX}/lib/libEGL_mesa.so.0
	ln -sf libGLX_mesa.so ${TERMUX_PREFIX}/lib/libGLX_mesa.so.0
}
