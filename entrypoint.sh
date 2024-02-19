#!/usr/bin/env nu

def main [] {
    ls
    cd pkgs
    chown packer ./ -R
    # ls | xargs -i sudo -u packer sh -c 'sh {}/my-arch-build.sh; mv {}/*.pkg.tar.zst ./; rm {} -rf'
    ls | each { |it|
		try { sh $"($it.name)/my-arch-build.sh" }
		try { rm $"($it.name)-debug*.pkg.tar.zst" }
		try { mv "*.pkg.tar.zst" ./ }
		try { rm $it.name -rf }
	}
}




