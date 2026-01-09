#! /bin/sh
PKGNAME="example"
BASEDIR=$(dirname "$0")
cd "$BASEDIR"

paru -G ${PKGNAME}
mv ./${PKGNAME}/* ./
rm ./${PKGNAME} -rf

#git clone https://git.archlinux.org/svntogit/packages.git --single-branch -b packages/${PKGNAME}
#mv ./packages/repos/extra-x86_64/* ./
#rm ./packages -rf


pkgver=${PKGNAME}-`cat PKGBUILD | sed -nE 's/^\s*pkgver\s*=\s*(\S+)/\1/p'`
pkgver=${pkgver}-`cat PKGBUILD | sed -nE 's/^\s*pkgrel\s*=\s*(\S+)/\1/p'`
oldpkgver=`cat /tmp/packages.txt | grep -e "${PKGNAME}-[0-9a-zA-Z]" | sed -n '$p'`

# git clone -b <br> <url> upstream-git --depth=1
# cd upstream-git
# pkgver=`git describe --always --dirty`
# cd ..
# rm upstream-git -rf

if [[ "$oldpkgver" == "" ]]
then
    oldpkgver='a'
fi

echo ${pkgver} ${oldpkgver}
if [[ `vercmp ${pkgver}-aaa ${oldpkgver}` == 1  ]]
# if [[ `echo ${oldpkgver} | grep ${pkgver}` == ""  ]]
then
    # makepkg -sf --noconfirm --skippgpcheck --skipchecksums
	paru -B --skipreview --noconfirm .
fi
