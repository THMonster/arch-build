#! /bin/sh
BASEDIR=$(dirname "$0")
cd "$BASEDIR"

makepkg -sf --noconfirm --skippgpcheck --skipchecksums
