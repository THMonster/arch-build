#! /bin/sh
BASEDIR=$(dirname "$0")
cd "$BASEDIR"
git clone https://git.archlinux.org/svntogit/packages.git --single-branch -b packages/linux
mv ./packages/repos/core-x86_64/* ./
rm ./packages -rf
cat PKGBUILD| sed -E  '/sha256sums=/a thisisalabel'| sed -E '/thisisalabel/,+1d'|sed -E '/sha256sums=/a 'SKIP'' > PKGBUILD.new
mv PKGBUILD.new PKGBUILD
cat myconfig >> config
cat config

pkgver="linux"
pkgver=${pkgver}-`cat PKGBUILD | sed -nE 's/^pkgver=([0-9.a-zA-Z]+)/\1/p'`
pkgver=${pkgver}-`cat PKGBUILD | sed -nE 's/^pkgrel=([0-9]+)/\1/p'`
oldpkgver=`curl https://api.github.com/repos/isoasflus/arch-build/releases -s | jq '.[0].assets' | grep '"name"' | sed -nE 's/^.+"name": "([^"]+)",$/\1/p' | grep -e 'linux-[0-9]' | sed -n '$p'`

if [[ $oldpkgver == "" ]]
then
    oldpkgver='a'
fi

echo ${pkgver} ${oldpkgver}
if [[ `vercmp ${pkgver} ${oldpkgver}` == 1  ]]
then
    sh -c 'sleep 900; rm ./archlinux-linux/.git -rf' & 
    MAKEFLAGS="-j2" makepkg -sf --noconfirm --skippgpcheck
fi
