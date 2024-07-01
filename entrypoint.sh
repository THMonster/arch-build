#!/usr/bin/env nu

def main [] {
    ls
    cd pkgs
    chown packer ./ -R
    try {
        touch /tmp/packages.txt
        curl https://api.github.com/repos/THMonster/arch-build/releases -s | from json | get 0.assets | sort-by created_at | get name | save -f /tmp/packages.txt
    }
    cat /etc/makepkg.conf | str replace -m -r '(^OPTIONS=\([^)]*)debug([^)]*\))' '${1}!debug$2' | save -f /tmp/makepkg.conf
    mv /tmp/makepkg.conf /etc/makepkg.conf
    ls | each { |it|
		try {
			sudo -u packer sh $"($it.name)/my-arch-build.sh"
        }
		# let pkg_d = (glob $"*/($it.name)-debug*.pkg.tar.zst")
		# try { $pkg_d | get 0 | rm $in }
		let pkg = (glob $"($it.name)/*.pkg.tar.zst")
		$pkg | each { |p|
    		try { mv $p ./ }
		}
		# try { $pkg | get 0 | mv $in ./ }
		tree -L 2
		try { rm $it.name -rf }
	}
}
