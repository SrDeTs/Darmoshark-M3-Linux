# Maintainer: Michael <michael@example.com>
_pkgbase_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
_project_version="$(sed -nE 's/^project\(DarmosharkM3 VERSION ([^ ]+) LANGUAGES CXX\)$/\1/p' "$_pkgbase_dir/CMakeLists.txt" | head -n 1)"

pkgname=darmoshark-m3
pkgver="${_project_version:-0.1}"
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
