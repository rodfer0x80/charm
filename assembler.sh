#!/bin/bash

# Check if a C file is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <asm_file>"
    exit 1
fi

# Assign the filename from the argument
ASM_FILE=$1
OBJ_FILE="$(basename "$1" .s).o"
ARM64_BIN="runme.arm64"

# Assemble the assembly code to generate an object file
aarch64-linux-gnu-as -o "$OBJ_FILE" "$ASM_FILE"

# Link the object file to generate an ARM64 binary
aarch64-linux-gnu-gcc -o "$ARM64_BIN"  "$OBJ_FILE"
rm "$OBJ_FILE"

# Run with qemu
qemu-aarch64 "$ARM64_BIN"

# Remove runme elf arm64 executable
#rm runme.arm64
