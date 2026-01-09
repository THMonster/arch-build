#!/usr/bin/env nu

# source misc.nu
source '../../scripts/misc.nu'

const BASEDIR = path self | path dirname
cd $BASEDIR

let PKGNAME = 'revda-dev-git'
let OWN_PKGS = [ 'revda-dev-git' ]

def main [plist: string, print_pkgs: bool] {
	if $print_pkgs == true {
		return ($OWN_PKGS | to json)
	}
	let plist = $plist | from json

	# download_pkgbuild $PKGNAME

	# let has_update = check_verion $PKGNAME $plist
	let has_update = check_verion_git 'https://github.com/THMonster/Revda' 'developing' $PKGNAME $plist
	if $has_update {
		# makepkg -sf --noconfirm --skippgpcheck --skipchecksums
		paru -B --skipreview --noconfirm .
	}
}

