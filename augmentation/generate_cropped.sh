#!/bin/bash

# Makes a copy of the original dataset, then crop over itself
# ...it's just easier

if test "$#" -ne 1; then
	echo "Bad param count! $0 <path_to_original_dataset>"
	exit 1
fi

echo "Generating cropped dataset..."

cp -r $1 cropped
cd cropped
find . -type f -exec convert {} -gravity center -crop 227x227+0+0 +repage {} \;
