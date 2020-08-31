#! /bin/sh
BASEDIR=$(dirname "$0")
cd "$BASEDIR"
yay -G proton-ge-custom-bin
mv ./proton-ge-custom-bin/* ./
rm ./proton-ge-custom-bin -rf

pkgver="proton-ge-custom-bin"
pkgver=${pkgver}-`cat PKGBUILD | sed -nE 's/^pkgver=([0-9._a-zA-Z]+)/\1/p'`
pkgver=${pkgver}-`cat PKGBUILD | sed -nE 's/^pkgrel=([0-9]+)/\1/p'`
oldpkgver=`curl https://api.github.com/repos/isoasflus/arch-build/releases -s | jq '.[0].assets' | grep '"name"' | sed -nE 's/^.+"name": "([^"]+)",$/\1/p' | grep -e 'proton-ge-custom-bin-[0-9]' | sed -n '$p'`

if [[ $oldpkgver == "" ]]
then
    oldpkgver='a'
fi

echo ${pkgver} ${oldpkgver}
if [[ `vercmp ${pkgver} ${oldpkgver}` == 1  ]]
then
    makepkg -sf --noconfirm --skippgpcheck
fi
