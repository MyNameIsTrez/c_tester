#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ln -snf "$SCRIPT_DIR" "$(pwd)/libctester"

MAKE_ARGS=""
if [[ $(echo $@ | grep "DEBUG") != "" ]]; then
	MAKE_ARGS+=" DEBUG=1" # the space is intentional to split the args
fi
if [[ $(echo $@ | grep "SAN") != "" ]]; then
	MAKE_ARGS+=" SAN=1" # the space is intentional to split the args
fi


make -C libctester TESTS_DIR="$(pwd)" $MAKE_ARGS --jobs=1


if [[ $(echo $@ | grep "RUN") != "" ]]; then
	"$(pwd)/libctester/ctester"
fi
