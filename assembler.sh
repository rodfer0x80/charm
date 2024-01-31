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

# Build the Docker image
BUILDER_NAME="charm64"
# Check if the builder already exists
if docker buildx inspect "$BUILDER_NAME" &> /dev/null; then
    echo "[*] Builder '$BUILDER_NAME' already exists."
else
    # Create the builder
    docker buildx create --name "$BUILDER_NAME" --use
    echo "[+] Builder '$BUILDER_NAME' created and set as active."
fi

# Build the Docker image
docker buildx build --load --platform linux/arm64 -t charm64 -f Dockerfile .
rm "$ARM64_BIN"

# Run the Docker container
docker run --platform linux/arm64 charm64

# Remove runme elf arm64 executable
#rm runme.arm64
