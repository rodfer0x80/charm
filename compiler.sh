#!/bin/bash

# Check if a C file is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <c_file>"
    exit 1
fi

# Assign the filename from the argument
C_FILE="$1"
ASM_FILE="$(basename "$1" .c).s"

# Compile the C file
aarch64-linux-gnu-gcc -O2 -S -o "$ASM_FILE" "$C_FILE"
