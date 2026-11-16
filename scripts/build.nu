#!/usr/bin/env nu

source misc.nu
# source '../../scripts/misc.nu'

const BASEDIR = path self | path dirname
cd $BASEDIR

let PKGNAME = 'pkg1'
let OWN_PKGS = [ 'pkg1' ]

def main [plist: string, print_pkgs: bool] {
	if $print_pkgs == true {
		return ($OWN_PKGS | to json)
	}
	let plist = $plist | from json

	download_pkgbuild $PKGNAME

	let has_update = check_verion $PKGNAME $plist
	# let has_update = check_verion_git '<url>' '<br>' $PKGNAME $plist
	if $has_update {
		# makepkg -sf --noconfirm --skippgpcheck --skipchecksums
		paru -B --skipreview --noconfirm .
	}

    # glob '/**/paru/**/*.pkg.tar.zst' | print
    # let _ = $OWN_PKGS | each { |p|
    #     let re1 = '.+/' + $p + r#'-[^-]+-[0-9]+-(any|x86_64).pkg.tar.zst'#
    #     glob '/**/paru/**/*.pkg.tar.zst' | where $it =~ $re1 | each { |f|
    #         'package file: ' + $f | print
    #         try { cp $f ./ }
    #     }
    # }
}

