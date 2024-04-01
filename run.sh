#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <arm64_bin>"
    exit 1
fi

ARM64_BIN="$1"

qemu-aarch64 "$ARM64_BIN"
RET=$?
rm "$ARM64_BIN"
exit $RET
