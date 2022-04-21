#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

pwd
rm -f "$SCRIPT_DIR/to_test"
ln -s "$(pwd)/$1" "$SCRIPT_DIR/to_test"
make -C "$SCRIPT_DIR"
# "$SCRIPT_DIR/test_all"
rm -f "$SCRIPT_DIR/to_test"
