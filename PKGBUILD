# Maintainer: Michael <michael@example.com>
pkgname=darmoshark-m3-configurator
pkgver=0.1
pkgrel=1
pkgdesc="Linux configurator for Darmoshark M3/N3/M3S mice"
arch=('x86_64')
url="http://www.darmoshark.cn/"
license=('GPL')
depends=('qt6-base' 'qt6-declarative' 'hidapi' 'libusb' 'tomlplusplus')
makedepends=('cmake' 'pkgconf' 'qt6-tools')
source=()
sha256sums=()

build() {
    cmake -B build -S . \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr
    cmake --build build
}

package() {
    DESTDIR="$pkgdir" cmake --install build
}
