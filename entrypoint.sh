#!/usr/bin/env nu

def main [] {
    ls
    cd pkgs
    chown packer ./ -R
    try {
        touch /tmp/packages.txt
        curl https://api.github.com/repos/THMonster/arch-build/releases -s | from json | get 0.assets | sort-by created_at | get name | save -f /tmp/packages.txt
    }
    # ls | xargs -i sudo -u packer sh -c 'sh {}/my-arch-build.sh; mv {}/*.pkg.tar.zst ./; rm {} -rf'
    ls | each { |it|
		try {
			sudo -u packer sh $"($it.name)/my-arch-build.sh"
        }
		let pkg_d = (glob $"*/($it.name)-debug*.pkg.tar.zst")
		try { $pkg_d | get 0 | rm $in }
		let pkg = (glob $"($it.name)/*.pkg.tar.zst")
		try { $pkg | get 0 | mv $in ./ }
		tree -L 2
		try { rm $it.name -rf }
	}
}
