################################################################################
#
##  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  #  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#  #
#  This Program is distributed in the hope that it will be useful,
#  #  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  #  GNU General Public License for more details.
#
##  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  #  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
#  ################################################################################

PKG_NAME="MythTV"
PKG_VERSION="0.28-pre"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://mythtv.org"
PKG_URL="https://github.com/MythTV/mythtv/archive/master.zip"
#PKG_DEPENDS_TARGET="bzip2 Python zlib:host zlib libpng taglib exiv2 tiff dbus glib liberation-fonts-ttf font-util font-xfree86-type1 font-misc-misc alsa"
PKG_DEPENDS_TARGET="taglib exiv2 qt5base qtwebkit"
PKG_PRIORITY="optional"
PKG_SECTION="lib"
PKG_SHORTDESC="MythTV DVR"
PKG_LONGDESC="MythTV - the ultimate Digital Video Recorder and home media center hub"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

unpack() {
  unzip -d $BUILD/ $SOURCES/mythtv/master.zip
  mv $BUILD/mythtv-master $BUILD/${PKG_NAME}-${PKG_VERSION}
}

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME

# ffmpeg fails building with LTO support
  strip_lto

# ffmpeg fails running with GOLD support
  strip_gold
}

configure_target() {

    case $PROJECT in
        Generic)
            #CPPFLAGS_SAVE=${CPPFLAGS}
            #CFLAGS_SAVE=${CFLAGS}
            #LDFLAGS_SAVE=${LDFLAGS}
            #YASMFLAGS_SAVE=${YASMFLAGS}

            #unset CPPFLAGS
            #unset CFLAGS
            #unset LDFLAGS
            #unset YASMFLAGS

            pushd ${ROOT}/${BUILD}/${PKG_NAME}-${PKG_VERSION}/mythtv
            echo "$SYSROOT_PREFIX: " $SYSROOT_PREFIX
            ./configure \
                --cpu=$TARGET_CPU \
                --arch=$TARGET_ARCH \
                --enable-cross-compile \
                --cross-prefix=$TARGET_PREFIX \
                --sysroot=$SYSROOT_PREFIX \
                --sysinclude="$SYSROOT_PREFIX/usr/include" \
                --target-os="linux" \
                --extra-version="$PKG_VERSION" \
                --nm="$NM" \
                --ar="$AR" \
                --as="$CC" \
                --cc="$CC" \
                --ld="$CC" \
                --host-cc="$HOST_CC" \
                --host-cflags="$HOST_CFLAGS" \
                --host-ldflags="$HOST_LDFLAGS" \
                --host-libs="-lm" \
                --extra-cflags="$CFLAGS" \
                --extra-ldflags="$LDFLAGS" \
                --extra-libs="" \
                --extra-version="" \
                --build-suffix="" \
                --disable-static \
                --enable-shared \
                --enable-gpl \
                --disable-version3 \
                --disable-nonfree \
                --enable-logging \
                --disable-doc \
                $FFMPEG_DEBUG \
                $FFMPEG_PIC \
                --pkg-config="$ROOT/$TOOLCHAIN/bin/pkg-config" \
                --enable-optimizations \
                --disable-armv5te --disable-armv6t2 \
                --disable-extra-warnings \
                --prefix=/usr \
                --enable-dvb \
                --libdir-name=lib64 \
                --compile-type=debug \
                --enable-silent-cc \
                --enable-nonfree
            popd

#CPPFLAGS=${CPPFLAGS_SAVE}
#CFLAGS=${CFLAGS_SAVE}
#LDFLAGS=${LDFLAGS_SAVE}
#YASMFLAGS=${YASMFLAGS_SAVE}

        ;;
        RPi)
        ;;
    esac
}

make_target() {
	case $PROJECT in
		Generic)
			pushd $ROOT/$BUILD/${PKG_NAME}-${PKG_VERSION}/mythtv
				make
			popd
		;;
		RPi)
		;;
	esac
}

makeinstall_target() {
	case $PROJECT in
		Generic)
			pushd ${ROOT}/${PKG_BUILD}
				mkdir .install_pkg || true
				DESTDIR=.install_pkg/ make install
			popd
		;;
		RPi)
		;;
	esac
}

#pre_install() {
#}

#post_install() {
#}
