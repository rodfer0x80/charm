#!/bin/sh

# Check if a C file is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <c_file>"
    exit 1
fi

# Assign the filename from the argument
C_FILE="$1"
ASM_FILE="$(basename "$1" .c).s"

"$PWD"/compiler.sh "$C_FILE"
"$PWD"/assembler.sh "$ASM_FILE"
RET=$?
rm "$ASM_FILE"
exit $RET
