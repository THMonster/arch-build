#! /bin/sh
BASEDIR=$(dirname "$0")
cd "$BASEDIR"
yay -G woeusb-ng
mv ./woeusb-ng/* ./
rm ./woeusb-ng -rf

pkgver="woeusb-ng"
pkgver=${pkgver}-`cat PKGBUILD | sed -nE 's/^pkgver=([0-9.a-zA-Z]+)/\1/p'`
pkgver=${pkgver}-`cat PKGBUILD | sed -nE 's/^pkgrel=([0-9]+)/\1/p'`
oldpkgver=`curl https://api.github.com/repos/THMonster/arch-build/releases -s | jq '.[0].assets' | grep '"name"' | sed -nE 's/^.+"name": "([^"]+)",$/\1/p' | grep -e 'woeusb-ng-[0-9]' | sed -n '$p'`

if [[ $oldpkgver == "" ]]
then
    oldpkgver='a'
fi

echo ${pkgver} ${oldpkgver}
if [[ `vercmp ${pkgver}-aaa ${oldpkgver}` == 1  ]]
then
    makepkg -sf --noconfirm --skippgpcheck --skipchecksums
fi
