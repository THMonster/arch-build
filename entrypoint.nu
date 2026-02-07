#!/usr/bin/env nu

let expected_packages = [ 'gamescope-session-git' 'papirus-icon-theme-git' ]

def main [] {
    ls
    cd pkgs
    chown packer ./ -R

	let resp = try {
		let resp = curl https://api.github.com/repos/THMonster/arch-build/releases/tags/packages -s | from json
		$resp | get assets | get name 
	} catch {
		[]
	} 
	let resp = $resp | to json 

	open /etc/makepkg.conf | str replace -m -r '(^OPTIONS=\([^)]*)debug([^)]*\))' '${1}!debug$2' | save -f /tmp/makepkg.conf
    mv /tmp/makepkg.conf /etc/makepkg.conf
    open /etc/makepkg.conf | print
	let _ = ls | each { |it|
		print ('===========================================building: ' + $it.name + '==================================================')
		let build_script = $it.name + "/build.nu"
		let pkgout = nu $build_script 'aaa' true | from json
		try {
			sudo -u packer nu $build_script $resp false
		} catch {
			if $pkgout.0 in $expected_packages {
				error make {msg: "This package should not be failed"}
			}
		}

		let _ = $pkgout | each { |p|
			let re1 = '.+/' + $p + r#'-[^-]+-[0-9]+-(any|x86_64).pkg.tar.zst'#
			glob '**/*.pkg.tar.zst' | where $it =~ $re1 | each { |f|
				'package file: ' + $f | print
				try { mv $f ./ }
			}
		}
		# tree -L 2
		try { rm $it.name -rf }
	}
}
