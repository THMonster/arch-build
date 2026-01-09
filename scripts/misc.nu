#!/usr/bin/env nu

def download_pkgbuild [pkgname: string] {
	# git clone https://git.archlinux.org/svntogit/packages.git --single-branch -b packages/${PKGNAME}
	# mv ./packages/repos/extra-x86_64/* ./
	# rm ./packages -rf
	paru -G $pkgname
	glob ('./' + $pkgname + '/*') | each { |x|
		mv $x ./
	}
	rm $pkgname -rf
}

# update if true
def check_verion [pkgname: string , plist: list<string>] {
	let pkgver = $pkgname + '-' +	(open PKGBUILD | parse -r r#'^\s*pkgver\s*=\s*["']*([^"']+)["']*'# | get capture0.0)
	let pkgver = $pkgver + '-' + (open PKGBUILD | parse -r r#'^\s*pkgrel\s*=\s*["']*([^"']+)["']*'# | get capture0.0) + '-aaa'
	print ('current pkgver: ' + $pkgver)

	let re1 = $pkgname + r#'-[^-]+-[0-9]+-(any|x86_64).pkg.tar.zst'#
	mut ret = true
	for $x in ($plist | where $it =~ $re1) {
		let cmp = vercmp $pkgver $x | into int
		if $cmp <= 0 { 
			$ret = false
		}
	}
	$ret
}

# update if true
def check_verion_git [url: string, br: string, pkgname: string , plist: list<string>] {
	git clone -b $br $url upstream-git --depth=1
	cd upstream-git
	let	pkgver = git describe --always | str substring 0..-3
	cd ..
	rm upstream-git -rf
	print ('current pkgver: ' + $pkgver)

	let re1 = $pkgname + r#'-[^-]+-[0-9]+-(any|x86_64).pkg.tar.zst'#
	mut ret = true
	for $x in ($plist | where $it =~ $re1) {
		if ($x | str contains $pkgver) { 
			$ret = false
		}
	}
	$ret
}
