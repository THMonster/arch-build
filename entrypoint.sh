#!/usr/bin/env nu

def main [] {
    ls
    cd pkgs
    chown packer ./ -R
    # ls | xargs -i sudo -u packer sh -c 'sh {}/my-arch-build.sh; mv {}/*.pkg.tar.zst ./; rm {} -rf'
    ls | each { |it|
		try { sudo -u packer sh $"($it.name)/my-arch-build.sh" }
		try { rm $"($it.name)/($it.name)-debug*.pkg.tar.zst" }
		try { mv $"($it.name)/*.pkg.tar.zst" ./ }
		try { rm $it.name -rf }
	}
}




