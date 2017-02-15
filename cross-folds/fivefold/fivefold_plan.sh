#!/bin/bash

# creates configs for fivefold cross validation

if test "$#" -ne 2; then
	echo "Bad param count! $0 <src_dir> <append_string>"
	exit 1
elif [[ "$2" == "augmented" ]]; then
	./generate_fivefolds.sh $1

	for file in $(ls Fivefolds/); do
		./generate_augmented_filelist.sh Fivefolds/${file}
	done
elif [[ "$2" == "cropped" ]]; then	
	./generate_fivefolds.sh $1
	
	for file in $(ls Fivefolds/); do
		cp Fivefolds/${file} cropped_${file}
	done
elif [[ "$2" == "flips" ]]; then
	./generate_fivefolds.sh $1

	for file in $(ls Fivefolds/); do
		./generate_flips_filelist.sh Fivefolds/${file}
	done
elif [[ "$2" == "rotate" ]]; then
	./generate_fivefolds.sh $1

	for file in $(ls Fivefolds/); do
		./generate_rotate_filelist.sh Fivefolds/${file}
	done
else
	echo "<append_string> must be in {augmented, cropped, flips, rotate}"
fi

