#!/bin/bash

ls
cd pkgs
ls | xargs -i sh {}/my-arch-build.sh
