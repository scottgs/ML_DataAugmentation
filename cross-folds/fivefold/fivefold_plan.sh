#!/bin/bash

# creates configs for fivefold cross validation

if test "$#" -ne 2; then
	echo "Bad param count! $0 <src_dir> <append_str>"
	exit 1
fi


labels=(A B C D E)
# $2_fivefold_$LABEL_test.txt
# $2_fivefold_$LABEL_train.txt

base_dir=$(pwd)
# so we don't lose where to write the output files, might not need it
# (no trailing slash, don't forget)

cd $1

cat_list=($(ls -1d */ | cut -d / -f 1 | sort))
#pure directory list, as an array
#should be agricultural, baseball, etc in alphabetical order

for label_idx in "${!labels[@]}"; do

	# for each tenfold, scrape each cat for the correct number
	# dump that to the correct file
	# invert scrape, dump to other file

	test_fname=${base_dir}/${2}_fivefold_${labels[$label_idx]}_test.txt
	train_fname=${base_dir}/${2}_fivefold_${labels[$label_idx]}_train.txt

	for cat_num in "${!cat_list[@]}"; do
		# selected are the files whose 2 digit id number ends in the selected label_idx number (0-4) and label_idx + 5
		selected_test=($(set -f;find ${cat_list[$cat_num]} -type f -regex ${cat_list[$cat_num]}/${cat_list[$cat_num]}[0-9][${label_idx}$((label_idx + 5))].*))
		# train is the inverse
		selected_train=($(set -f;find ${cat_list[$cat_num]} -type f -regex ${cat_list[$cat_num]}/${cat_list[$cat_num]}[0-9][^${label_idx}$((label_idx + 5))].*))

		wait
		# Making a 15 MB text file line by line, super speedy :/

		for selected in "${selected_test[@]}"; do
			echo "${selected} ${cat_num}" >> ${test_fname}
		done

		for selected in "${selected_train[@]}"; do
			echo "${selected} ${cat_num}" >> ${train_fname}
		done
	done
done