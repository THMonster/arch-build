#! /bin/sh
BASEDIR=$(dirname "$0")
cd "$BASEDIR"
git clone "https://aur.archlinux.org/vapoursynth-editor.git"
mv ./vapoursynth-editor/* ./
makepkg -sf --noconfirm
