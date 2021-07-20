#!/bin/bash

ls
cd pkgs
chown packer ./ -R
ls | xargs -i sudo -u packer sh -c 'sh {}/my-arch-build.sh; mv {}/*.pkg.tar.zst ./; rm {} -rf'
