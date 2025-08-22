#!/bin/bash
# usage: ./create-sfx.sh /some/path/to/msys64 installer.exe

set -e

# Download and extract https://github.com/mcmilk/7-Zip-zstd
NAME="7z25.01-zstd-x64"
CHECKSUM="d140094f0277b49a4e895159bd734da03cd2b60fb73a65e4151edfedc612981e"
DIR="$( cd "$( dirname "$0" )" && pwd )"
mkdir -p "$DIR/_cache"
BASE="$DIR/_cache/$NAME"
if [ ! -f "$BASE.exe" ]; then
    curl --fail -L "https://github.com/mcmilk/7-Zip-zstd/releases/download/v25.01-v1.5.7-R1/$NAME.exe" -o "$BASE.exe"
fi
echo "$CHECKSUM $BASE.exe" | sha256sum --quiet --check
if [ ! -d "$BASE" ]; then
    7z e -o"$BASE" "$DIR/_cache/$NAME.exe"
fi

# Creat SFX installer
INPUT="$1"
OUTPUT="$2"
TEMP="$OUTPUT.payload"

rm -f "$TEMP"
"$BASE/7z" a "$TEMP" -ms1T -m0=zstd -mx22 "$INPUT"
cat "$BASE/7zCon.sfx" "$TEMP" > "$OUTPUT"
rm "$TEMP"
