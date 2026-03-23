# Maintainer: Michael <michael@example.com>
pkgname=darmoshark-m3
pkgver=0.1
pkgrel=1
pkgdesc="Linux software for Darmoshark M3/N3/M3S mice"
arch=('x86_64')
url="http://www.darmoshark.cn/"
license=('GPL')
depends=('qt6-base' 'qt6-declarative' 'hidapi' 'libusb' 'tomlplusplus')
makedepends=('cmake' 'pkgconf' 'qt6-tools')
source=()
sha256sums=()

build() {
    cmake -B "$srcdir/build" -S "$startdir" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr
    cmake --build "$srcdir/build"
}

package() {
    DESTDIR="$pkgdir" cmake --install "$srcdir/build"
}
