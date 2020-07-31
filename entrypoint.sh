#!/bin/bash

mv /inner-pkgs ./
cd inner-pkgs
ls | xargs -i sh {}/my-arch-build.sh
