#! /bin/sh
BASEDIR=$(dirname "$0")
cd "$BASEDIR"
yay -G digimend-kernel-drivers-dkms-git
mv ./digimend-kernel-drivers-dkms-git/* ./
rm ./digimend-kernel-drivers-dkms-git -rf

makepkg -sf --noconfirm --skippgpcheck
