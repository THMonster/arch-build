#!/bin/bash

ls
cd pkgs
ls | xargs -i sudo -u nobody sh -c 'sh {}/my-arch-build.sh; mv {}/*.pkg.tar.zst ./; rm {} -rf'
