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

# generate a bunch of angles for rotations
angles=($(
	rotation_max=7
	rotation_step=1
	base_angles=(90 180 270) # handle zero on its own so we don't have negative angles
	all_angles=(90 180 270) # prevent duplicate from +-0 and just start at 1
	for minor_angle in $(seq 1 ${rotation_step} ${rotation_max}); do
		for src_angle in "${base_angles[@]}"; do
			all_angles+=($((src_angle - minor_angle)))
			all_angles+=($((src_angle + minor_angle)))
		done
		all_angles+=($minor_angle) # 0 + angle
		all_angles+=($((360 - minor_angle))) # 0 - angle
	done
	all_angles+=(0) # 0 itself

	# 0-pad them all to 3 digits and be lazy and just capture them
	for angle in ${all_angles[@]}; do
		printf "%03d\n" $angle
	done
))

cp -r $1 rotate
cd rotate

# parallelizing this correctly without letting it just fork bomb the machine is... difficult
# I could easily parallelize the angles and wait for them... but that's 60 processes.
# ...ADVENTURE!
source_files=($(find . -type f))
for file in "${source_files[@]}"; do
	echo $file
	for angle in "${angles[@]}"; do
		(
			new_fname="${file%.tif}_rot_${angle}.tif"
			convert ${file} -rotate ${angle} +repage -gravity center -crop 227x227+0+0 +repage ${new_fname}
		) &
	done
	wait
	rm $file
done

