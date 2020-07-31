#!/bin/bash

cd /inner-pkgs
ls | xargs -i sh {}/my-arch-build.sh
