#!/bin/sh

#
# Convert a trimmed version of the verfied test vectors
# to C code to be included in unit tests
#
# This script converts the 128-bit key test vectors
#

cat "$1" | grep -v -e "^====" -e "Test" -e "^$" | while read name; do

read key
read iv


for i in {1..4}; do
  echo "{ // $name"
  echo "  uint8_t key[16] = { $(echo "$key" | awk '{print $NF}' | sed 's/\(..\)/0x\1, /g' | sed 's/ $//') };"
  echo "  uint8_t n[8] = { $(echo "$iv" | awk '{print $NF}' | sed 's/\(..\)/0x\1, /g' | sed 's/ $//') };"
  echo "  uint8_t keystream[64] = { 0 };"
  echo "  uint8_t expected[64] = {"
  read stream
  index=$(echo "$stream" | awk -F. '{print $1}' | awk -F'[' '{print $2}')
  echo "    $(echo "$stream" | awk '{print $NF}' | sed 's/\(..\)/0x\1, /g' | sed 's/ $//')"
  read stream
  echo "    $(echo "$stream" | awk '{print $NF}' | sed 's/\(..\)/0x\1, /g' | sed 's/ $//')"
  read stream
  echo "    $(echo "$stream" | awk '{print $NF}' | sed 's/\(..\)/0x\1, /g' | sed 's/ $//')"
  read stream
  echo "    $(echo "$stream" | awk '{print $NF}' | sed 's/\(..\)/0x\1, /g' | sed 's/ $//') };"
  echo "  s20_crypt(key, 128, n, $index, keystream, 64);"
  echo "  au_eq(\"128-bit test vector, $name\", memcmp(keystream, expected, 64), 0);"
  echo "}"
  echo ""
done

read xor
read xor
read xor
read xor

done