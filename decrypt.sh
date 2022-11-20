#!/bin/bash

if [ $# -lt 3 ]
then
	echo "useage: $0 <medianame> <media chipcount> <keyname>"
	exit 1
fi

strkey=$(hexdump -v -e '16/1 "%02x"' $3)

> filelist.list

for i in $(seq 0 $2)
do
	iv=$(printf '%032x' $i)

	openssl aes-128-cbc -d -in $1_$i.ts -out $1_out_$i.ts -nosalt -iv $iv -K $strkey
	echo "file '$1_out_$i.ts'" >> filelist.list
done

ffmpeg -f concat -safe 0 -i filelist.list -c copy ./$1.mp4
