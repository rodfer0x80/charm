#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

filename=$1
output="${filename%.*}_arm"

arm-none-eabi-as -o "${output}.o" "$filename"
arm-none-eabi-ld -o "$output" "${output}.o"
rm "${output}.o"
qemu-arm -L /usr/arm-none-eabi/ "$output"
#rm "$output"
