#!/usr/bin/env nu

let expected_packages = [ 'gamescope-session-git' 'papirus-icon-theme-git' ]

def main [] {
    ls
    cd pkgs
    chown packer ./ -R
	sudo -u packer git config --global user.email "a@a.com"
	sudo -u packer git config --global user.name "aaa"

    let resp = try {
        let resp = curl 'https://api.github.com/repos/THMonster/arch-build/releases/tags/x86_64' -s | from json
        $resp | get assets | where name =~ '.+\.pkg\.tar\.zst$' | select name id created_at
    } catch {
        []
    } 
    let plist = $resp | get name | to json 
    print $plist

    try { wget 'https://github.com/THMonster/arch-build/releases/download/x86_64/THMonster.db' -O 'THMonster.db.tar.gz' }

	open /etc/makepkg.conf | str replace -m -r '(^OPTIONS=\([^)]*)debug([^)]*\))' '${1}!debug$2' | save -f /tmp/makepkg.conf
    mv /tmp/makepkg.conf /etc/makepkg.conf
    open /etc/makepkg.conf | print

    mut to_delete = []
    mut abandoned = $resp
    for $it in (ls | where type == dir) {
        print ('===========================================building: ' + $it.name + '==================================================')
        let build_script = $it.name + "/build.nu"
        let pkgout = nu $build_script 'aaa' true | from json
        try {
            sudo -u packer nu $build_script $plist false
        } catch {
            if $pkgout.0 in $expected_packages {
                error make {msg: "This package should not be failed"}
            } else {
                print ("::warning ::build failed: " + $pkgout.0)
            }
        }

        for $p in $pkgout {
            let re1 = $p + r#'-[^-]+-[0-9]+-(any|x86_64).pkg.tar.zst'#
            for $f in (glob ($it.name + '/*.pkg.tar.zst') | where $it =~ $re1) {
                'package file: ' + $f | print
                let pl = $abandoned | where name =~ $re1 | sort-by created_at
                if ($pl | length) > 1 {
                    $to_delete = $to_delete | append $pl.0 
                }
                repo-add THMonster.db.tar.gz $f
                try { mv $f ./ }
            }
            $abandoned = $abandoned | where name !~ $re1
        }
        try { rm $it.name -rf }
    }

    tree -L 2

    for $x in $abandoned {
        if (((date now) - ($x.created_at | into datetime)) > 3day) {
            $to_delete = $to_delete | append $x
            let pname = $x.name | parse -r '(.+)-[^-]+-[0-9]+-(any|x86_64).pkg.tar.zst' | get capture0.0
            try { repo-remove THMonster.db.tar.gz $pname }
        }
    }
    cp THMonster.db.tar.gz THMonster.db

    '============================all packages==============================' | print
    $resp | print
    '==================================to delete==============================' | print
    $to_delete | print
    '=============================orphan packages==============================' | print
    $abandoned | print

    $to_delete | to json | save to_delete.json
}
