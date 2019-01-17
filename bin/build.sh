#!/bin/bash

output='encrypt-to-list.app'

die() {
    printf '%s\n' "$*" >&2
    exit 1
}

cd "${BASH_SOURCE%/*}/" || die "Can't locate build script"
cd ..

[[ -f ./src/fruity-groups.applescript ]] || die "no src"
[[ -d ./build/ ]] || die "no build dir"
[[ -f ./resources/applet.icns ]] || die "missing icon"

osacompile -o ./build/$output ./src/fruity-groups.applescript

cp ./resources/applet.icns ./build/$output/Contents/Resources/

