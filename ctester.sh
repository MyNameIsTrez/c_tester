#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ln -s "$SCRIPT_DIR" "$(pwd)/libctester"
make -C libctester TESTS_DIR="$(pwd)"

if [ $# -eq 0 ]; then
	./libctester/ctester
fi
