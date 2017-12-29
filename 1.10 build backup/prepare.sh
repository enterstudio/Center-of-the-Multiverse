#!/bin/bash -e
find ./src/ -name '*.jar' | while read file; do
	if [ ! -e "${file}.url.txt" ]; then
		echo Deleting dangling file `basename $file`...
		rm $file
	fi
done
find ./ -name '*.url.txt' | while read file; do
	basename=${file%.url.txt}
	if [ ! -e "$basename" ]; then
		url=`cat $file`
		echo Downloading $url...
		curl -L -s "$url" -o "$basename"
	else
		echo Skipping download of existing file `basename $basename`
	fi
done