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

pkgver=`cat PKGBUILD | sed -nE 's/^pkgver=([0-9.a-zA-Z]+)/\1/p'`
pkgver=${pkgver}`cat PKGBUILD | sed -nE 's/^pkgrel=([0-9]+)/\1/p'`
oldpkgver=`cat ../../pkglist.txt | sed -nE 's/^linux=([0-9.a-zA-Z]+)/\1/p'`

if [[ $oldpkgver == "" ]]
then
    echo "linux=0" >> ../../pkglist.txt
fi

echo ${pkgver} ${oldpkgver}
if [[ $pkgver != $oldpkgver ]]
then
    # makepkg -sf --noconfirm --skippgpcheck && sed -i -E 's/linux=[0-9.a-zA-Z]+/linux='${pkgver}'/g' ../../pkglist.txt
    sed -i -E 's/^linux=[0-9.a-zA-Z]+/linux='${pkgver}'/g' ../../pkglist.txt
fi
cat ../../pkglist.txt
