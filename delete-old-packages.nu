#!/usr/bin/env nu

def delete_assets [token:string, id: string] {
	"delete asset id: " + $id | print
	let resp = (curl -L -X DELETE
	 	-H "Accept: application/vnd.github+json"
		-H $"Authorization: Bearer ($token)"
		-H "X-GitHub-Api-Version: 2022-11-28"
		("https://api.github.com/repos/THMonster/arch-build/releases/assets/" + $id))
	$resp | print
}

def main [token: string] {
	let package_list = glob './pkgs/**/build.nu' | each { |x|
		nu $x 'aaa' true | from json
	} | reduce -f [] { |it, acc| 
		$acc | append $it
	}

	let packages = try {
		let resp = curl https://api.github.com/repos/THMonster/arch-build/releases/tags/packages -s | from json
		$resp | get assets | select name id created_at
	} catch {
		[]
	}

	mut to_delete = []
	mut abandoned = $packages
	for $p in $package_list {
		let re1 = $p + r#'-[^-]+-[0-9]+-(any|x86_64).pkg.tar.zst'#
		let pl = $packages | where name =~ $re1 | sort-by created_at
		$abandoned = $abandoned | where name !~ $re1
		if ($pl | length) > 2 {
			$to_delete = $to_delete | append $pl.0 
		}
	}

	'============================all packages==============================' | print
	$packages | print
	'==================================to delete==============================' | print
	$to_delete | print
	'=============================orphan packages==============================' | print
	$abandoned | print
	let _ =	$to_delete | each { |x| 
		delete_assets $token ($x.id | into string)
	}

	let _ =	$abandoned | each { |x| 
		if (((date now) - ($x.created_at | into datetime)) > 3day) {
			delete_assets $token ($x.id | into string)
		}
	}
}
