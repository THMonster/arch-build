#!/bin/bash

ls
cd pkgs
chown packer ./ -R
ls | xargs -i sh -c 'sh {}/my-arch-build.sh; mv {}/*.pkg.tar.zst ./; rm {} -rf'
