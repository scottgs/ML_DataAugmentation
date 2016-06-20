#!/bin/bash

# copy merced data over, run the cropper in the background on it
# This is hard to parallelize because bash and laziness
#   and the serial version takes much too long
# This will, however, spawn 60 jobs and wait about 2100 times
# Disable that by commenting out lines 51, 60, and 62.

# rotate, then flip

if test "$#" -ne 1; then
	echo "Bad param count! $0 <path_to_original_dataset>"
	exit 1
fi

echo "Generating augmented dataset..."

cp -r $1 flipped
cd flipped

# parallelizing this correctly without letting it just fork bomb the machine is... difficult
# I could easily parallelize the angles and wait for them... but that's 60 processes.
# ...ADVENTURE!
source_files=($(find . -type f))
for file in "${source_files[@]}"; do
	echo $file
	convert ${file} -flip +repage ${file%.tif}_flip_v.tif &
	convert ${file} -flop +repage ${file%.tif}_flip_h.tif &
	wait
	mv ${file} ${file%.tif}_flip_n.tif
done

