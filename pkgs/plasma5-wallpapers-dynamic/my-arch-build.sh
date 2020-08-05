#! /bin/sh
BASEDIR=$(dirname "$0")
cd "$BASEDIR"
yay -G plasma5-wallpapers-dynamic
mv ./plasma5-wallpapers-dynamic/* ./
rm ./plasma5-wallpapers-dynamic -rf

pkgver="plasma5-wallpapers-dynamic"
pkgver=${pkgver}-`cat PKGBUILD | sed -nE 's/^pkgver=([0-9.a-zA-Z]+)/\1/p'`
pkgver=${pkgver}-`cat PKGBUILD | sed -nE 's/^pkgrel=([0-9]+)/\1/p'`
oldpkgver=`curl https://api.github.com/repos/isoasflus/arch-build/releases -s | jq '.[0].assets' | grep '"name"' | sed -nE 's/^.+"name": "([^"]+)",$/\1/p' | grep -e 'plasma5-wallpapers-dynamic' | sed -n '$p'`

if [[ $oldpkgver == "" ]]
then
    oldpkgver='a'
fi

echo ${pkgver} ${oldpkgver}
if [[ `vercmp ${pkgver} ${oldpkgver}` == 1  ]]
then
    makepkg -sf --noconfirm --skippgpcheck
fi
