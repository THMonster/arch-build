#! /bin/sh
BASEDIR=$(dirname "$0")
cd "$BASEDIR"
yay -G mpd
git clone https://git.archlinux.org/svntogit/packages.git --single-branch -b packages/mpd
mv ./packages/repos/extra-x86_64/* ./
rm ./packages -rf

pkgver="mpd"
pkgver=${pkgver}-`cat PKGBUILD | sed -nE 's/^pkgver=([0-9.a-zA-Z]+)/\1/p'`
pkgver=${pkgver}-`cat PKGBUILD | sed -nE 's/^pkgrel=([0-9]+)/\1/p'`
oldpkgver=`curl https://api.github.com/repos/isoasflus/arch-build/releases -s | jq '.[0].assets' | grep '"name"' | sed -nE 's/^.+"name": "([^"]+)",$/\1/p' | grep -e 'mpd-[0-9]' | sed -n '$p'`

if [[ $oldpkgver == "" ]]
then
    oldpkgver='a'
fi

echo ${pkgver} ${oldpkgver}
if [[ `vercmp ${pkgver} ${oldpkgver}` == 1  ]]
then
    mpdver=v`cat PKGBUILD | sed -nE 's/^pkgver=([0-9.a-zA-Z]+)/\1/p'`
    git clone https://github.com/IsoaSFlus/MPD.git
    cd MPD
    git fetch https://github.com/MusicPlayerDaemon/MPD.git master:tmp
    git merge ${mpdver} --ff-only || exit 1
    cd ..
    mv MPD mpd-`cat PKGBUILD | sed -nE 's/^pkgver=([0-9.a-zA-Z]+)/\1/p'`
    tar cvf mpd-`cat PKGBUILD | sed -nE 's/^pkgver=([0-9.a-zA-Z]+)/\1/p'`.tar.xz mpd-`cat PKGBUILD | sed -nE 's/^pkgver=([0-9.a-zA-Z]+)/\1/p'`
    makepkg -sf --noconfirm --skippgpcheck --skipchecksums
fi
