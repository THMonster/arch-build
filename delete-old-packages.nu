#!/usr/bin/env nu

def delete_assets [token:string, id: string] {
	print ("delete asset id: " + $id)
	let resp = (curl -L -X DELETE
	 	-H "Accept: application/vnd.github+json"
		-H $"Authorization: Bearer ($token)"
		-H "X-GitHub-Api-Version: 2022-11-28"
		("https://api.github.com/repos/THMonster/arch-build/releases/assets/" + $id))
	print $resp
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

	let packages_out = $package_list | each { |p| 
		let re1 = $p + r#'-[^-]+-[0-9]+-(any|x86_64).pkg.tar.zst'#
		let pl = $packages | where name =~ $re1 | sort-by created_at
		mut to_delete = []
		if ($pl | length) > 2 {
			$to_delete = $to_delete | append $pl.0 
		}
		{ $p: [$pl $to_delete] }
	} | into record 

	print ($packages_out | to json)
	let _ =	$packages_out | items { |k, v| 
		let id = ($v.1 | get -o id.0)
		if ($id | is-not-empty) {
			delete_assets $token ($id | into string)
		}
	}
	
}
