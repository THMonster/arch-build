#!/usr/bin/env nu

# source misc.nu
source '../../scripts/misc.nu'

const BASEDIR = path self | path dirname
cd $BASEDIR

let PKGNAME = 'yt-dlp-git'
let OWN_PKGS = [ 'yt-dlp-git' ]

def main [plist: string, print_pkgs: bool] {
	if $print_pkgs == true {
		return ($OWN_PKGS | to json)
	}
	let plist = $plist | from json

	download_pkgbuild $PKGNAME

	# let has_update = check_verion $PKGNAME $plist
	let has_update = check_verion_git 'https://github.com/yt-dlp/yt-dlp' 'master' $PKGNAME $plist
	if $has_update {
		paru -B --skipreview --noconfirm .
		# makepkg -sf --noconfirm --skippgpcheck --skipchecksums
	}
}


