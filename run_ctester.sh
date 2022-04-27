#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ln -sn "$SCRIPT_DIR" "$(pwd)/libctester"

make -C libctester TESTS_DIR="$(pwd)" --jobs=1

if [ $# -eq 0 ]; then
	"$(pwd)/libctester/ctester"
fi
