#! /bin/sh
BASEDIR=$(dirname "$0")
cd "$BASEDIR"
yay -G linux
mv ./linux/* ./
rm ./linux -rf
cat PKGBUILD| sed -E  '/sha256sums=/a thisisalabel'| sed -E '/thisisalabel/,+1d'|sed -E '/sha256sums=/a 'SKIP'' > PKGBUILD.new
mv PKGBUILD.new PKGBUILD
cat myconfig >> config
cat config
makepkg -sf --noconfirm
