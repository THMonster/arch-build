#! /bin/sh
PKGNAME="gamescope-git"
BASEDIR=$(dirname "$0")
cd "$BASEDIR"

paru -G ${PKGNAME}
mv ./${PKGNAME}/* ./
rm ./${PKGNAME} -rf

#git clone https://git.archlinux.org/svntogit/packages.git --single-branch -b packages/${PKGNAME}
#mv ./packages/repos/extra-x86_64/* ./
#rm ./packages -rf


pkgver=${PKGNAME}-`cat PKGBUILD | sed -nE 's/^pkgver=([0-9.a-zA-Z]+)/\1/p'`
pkgver=${pkgver}-`cat PKGBUILD | sed -nE 's/^pkgrel=([0-9]+)/\1/p'`
# oldpkgver=`curl https://api.github.com/repos/THMonster/arch-build/releases -s | jq '.[0].assets' | grep '"name"' | sed -nE 's/^.+"name": "([^"]+)",$/\1/p' | grep -e "${PKGNAME}-[0-9a-zA-Z]" | sed -n '$p'`
oldpkgver=`cat /tmp/packages.txt | grep -e "${PKGNAME}-[0-9a-zA-Z]" | sed -n '$p'`

git clone -b master https://github.com/ValveSoftware/gamescope upstream-git --depth=1
cd upstream-git
pkgver=`git describe --always --dirty`
cd ..

if [[ $oldpkgver == "" ]]
then
    oldpkgver='a'
fi

echo ${pkgver} ${oldpkgver}
# if [[ `vercmp ${pkgver}-aaa ${oldpkgver}` == 1  ]]
if [[ `echo ${oldpkgver} | grep ${pkgver}` == ""  ]]
then
	paru -B --skipreview --noconfirm .
fi
