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
    let to_delete = open ./pkgs/to_delete.json

    for $p in $to_delete {
        delete_assets $token ($p.id | into string)
    }
}
