#! /bin/sh
PKGNAME="wps-office"
BASEDIR=$(dirname "$0")
cd "$BASEDIR"

yay -G ${PKGNAME}
mv ./${PKGNAME}/* ./
rm ./${PKGNAME} -rf

#git clone https://git.archlinux.org/svntogit/packages.git --single-branch -b packages/${PKGNAME}
#mv ./packages/repos/extra-x86_64/* ./
#rm ./packages -rf

pkgver=${PKGNAME}-`cat PKGBUILD | sed -nE 's/^pkgver=([0-9.a-zA-Z]+)/\1/p'`
pkgver=${pkgver}-`cat PKGBUILD | sed -nE 's/^pkgrel=([0-9]+)/\1/p'`
oldpkgver=`curl https://api.github.com/repos/THMonster/arch-build/releases -s | jq '.[0].assets' | grep '"name"' | sed -nE 's/^.+"name": "([^"]+)",$/\1/p' | grep -e "${PKGNAME}-[0-9]" | sed -n '$p'`

if [[ $oldpkgver == "" ]]
then
    oldpkgver='a'
fi

echo ${pkgver} ${oldpkgver}
if [[ `vercmp ${pkgver}-aaa ${oldpkgver}` == 1  ]]
then
    makepkg -sf --noconfirm --skippgpcheck --skipchecksums
fi
