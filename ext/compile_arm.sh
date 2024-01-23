#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <filename.s>"
    exit 1
fi

filename=$1
output="${filename%.*}"

arm-none-eabi-gcc -g -S -O2 "$filename" -o "${output}.s"

