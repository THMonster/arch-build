#!/usr/bin/env nu

def main [] {
    ls
    cd pkgs
    chown packer ./ -R
    # ls | xargs -i sudo -u packer sh -c 'sh {}/my-arch-build.sh; mv {}/*.pkg.tar.zst ./; rm {} -rf'
    ls | each { |it|
		try { 
			sudo -u packer sh $"($it.name)/my-arch-build.sh" 
        }
		let pkg = (glob $"($it.name)/*.pkg.tar.zst")
		let pkg_d = (glob $"*/($it.name)-debug*.pkg.tar.zst")
		try { $pkg_d | get 0 | rm $in }
		try { $pkg | get 0 | mv $in ./ }
		tree -L 2
		try { rm $it.name -rf }
	}
}




