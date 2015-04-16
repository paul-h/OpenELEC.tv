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

PKG_NAME="qt5webkit"
PKG_VERSION="5.4.1"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://qt-project.org"
PKG_URL="http://download.qt.io/official_releases/qt/5.4/5.4.1/submodules/qtwebkit-opensource-src-5.4.1.tar.gz"

case $PROJECT in
 Generic)
  PKG_DEPENDS_TARGET="bzip2 Python zlib:host zlib libpng tiff dbus glib fontconfig liberation-fonts-ttf font-util font-xfree86-type1 font-misc-misc alsa libICE libSM libXcursor libXtst pciutils nss qt5base"
 ;;
 RPi)
  PKG_DEPENDS_TARGET="bcm2835-driver bzip2 Python zlib:host zlib libpng tiff dbus glib fontconfig liberation-fonts-ttf font-util font-xfree86-type1 font-misc-misc alsa libICE libSM libXcursor libXtst nss qt5base"
 ;;
esac

PKG_PRIORITY="optional"
PKG_SECTION="lib"
PKG_SHORTDESC="Qt WebKit module"
PKG_LONGDESC="Qt Webkit module"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

unpack() {
   tar -xzf $SOURCES/${PKG_NAME}/qtwebkit-opensource-src-${PKG_VERSION}.tar.gz -C $BUILD/
   mv $BUILD/qtwebkit-opensource-src-${PKG_VERSION} $BUILD/${PKG_NAME}-${PKG_VERSION}
}

configure_target() {
    pushd ${ROOT}/${BUILD}/${PKG_NAME}-${PKG_VERSION}
    $SYSROOT_PREFIX/usr/bin/qmake
    popd
}

make_target() {
   echo "***** - " ${ROOT}/${BUILD}/${PKG_NAME}-${PKG_VERSION}
   pushd ${ROOT}/${BUILD}/${PKG_NAME}-${PKG_VERSION}
   make
   popd
}

makeinstall_target() {
   pushd ${ROOT}/${PKG_BUILD}
   make install
   popd
}

pre_install() {
  makeinstall_target
}
