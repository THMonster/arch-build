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
def check_verion [pkgname: string , plist: table] {
	# let pkgver = $pkgname + '-' +	(open PKGBUILD | lines | parse -r r#'^\s*pkgver\s*=\s*["']*([^"']+)["']*'# | get capture0.0)
	# let pkgver = $pkgver + '-' + (open PKGBUILD | lines | parse -r r#'^\s*pkgrel\s*=\s*["']*([^"']+)["']*'# | get capture0.0) + '-aaa'
	# print ('current pkgver: ' + $pkgver)
	#
	# let re1 = $pkgname + r#'-[^-]+-[0-9]+-(any|x86_64).pkg.tar.zst'#
	# mut ret = true
	# for $x in ($plist | where $it =~ $re1) {
	# 	let cmp = vercmp $pkgver $x | into int
	# 	if $cmp <= 0 { 
	# 		$ret = false
	# 	}
	# }
	# $ret
    false
}

# update if true
def check_verion_git [url: string, br: string, pkgname: string , plist: table] {
	# git clone -b $br $url upstream-git --depth=1
	# cd upstream-git
	# let	pkgver = git describe --always | str substring 0..-3
	# cd ..
	# rm upstream-git -rf
	# print ('current pkgver: ' + $pkgver)
	#
	# let re1 = $pkgname + r#'-[^-]+-[0-9]+-(any|x86_64).pkg.tar.zst'#
	# mut ret = true
	# for $x in ($plist | where $it =~ $re1) {
	# 	if ($x | str contains $pkgver) { 
	# 		$ret = false
	# 	}
	# }
	# $ret
    false
}

def check_version [pkgname: string, plist: table<name: string, version: string>, is_git: bool = false] {
    if $is_git {
        makepkg --nobuild -d
    }

    let src_info = makepkg --printsrcinfo | parse -r '(?<k>\S+)\s+=\s+(?<v>.+)'
    print $src_info

    mut epoch = ''
    mut pkgver = ''
    mut pkgrel = ''

    for $kv in $src_info {
        match ($kv | get k) {
            "epoch" => { $epoch = $kv | get v }
            "pkgver" => { $pkgver = $kv | get v }
            "pkgrel" => { $pkgrel = $kv | get v }
            _ => {}
            }
    }
    
    let final_ver = if ($epoch | is-empty) {
        $pkgver + '-' + $pkgrel
    } else {
        $epoch + ':' + $pkgver + '-' + $pkgrel
    }
	print ('new version: ' + $final_ver)

    let old_ver =  $plist | where name == $pkgname | get -o 0.version
	print ('old version: ' + $old_ver)
    
    let cmp = vercmp $final_ver $old_ver | into int
    if $cmp <= 0 { 
        return false
    } else {
        return true
    }
}
