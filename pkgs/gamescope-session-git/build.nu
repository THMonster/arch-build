#!/usr/bin/env nu

# source misc.nu
source '../../scripts/misc.nu'

const BASEDIR = path self | path dirname
cd $BASEDIR

let PKGNAME = 'gamescope-session-git'
let OWN_PKGS = [ 'gamescope-session-git' ]

def main [plist: string, print_pkgs: bool] {
	if $print_pkgs == true {
		return ($OWN_PKGS | to json)
	}
	let plist = $plist | from json

	# download_pkgbuild $PKGNAME

	# let has_update = check_verion $PKGNAME $plist
	let has_update = check_verion_git 'https://github.com/ChimeraOS/gamescope-session' 'main' $PKGNAME $plist
	if $has_update {
		# makepkg -sf --noconfirm --skippgpcheck --skipchecksums
		paru -B --skipreview --noconfirm .
	}
}


