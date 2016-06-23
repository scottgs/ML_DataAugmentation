#!/bin/bash

# Makes a copy of the original dataset, then crop over itself
# ...it's just easier

if test "$#" -ne 1; then
	echo "Bad param count! $0 <path_to_original_dataset>"
	exit 1
fi

echo "Generating resized dataset..."

cp -r $1 resize_${1}
cd resize_${1}
for file in $(find . -type f); do
	convert ${file} -resize 256x256 +repage ${file%.jpg}.tif
done
#find . -type f -exec convert {} -resize 256x256 +repage -gravity center -crop 227x227+0+0 +repage {}.tif \;
