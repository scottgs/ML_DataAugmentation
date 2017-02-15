#!/bin/bash

if test "$#" -ne 1; then
	echo "Bad param count! $0 <fold_file_list>"
	exit 1
fi

name=$(basename $1)
file_list=$(cat $1)
categories=($(cat $1 | cut -d / -f 1 | uniq))
num_categories=(${!categories[@]})
declare -A category_dict
for key in ${num_categories[@]}; do
	category_dict+=( [${categories[${key}]}]=${key} )
done

for file in $file_list; do 
	current_category=$(echo $file | cut -d / -f 1 )
	num=$(echo ${category_dict[${current_category}]})
	echo "${file},${num}" >> temp.txt
done

name=$(basename $1)
cur_dir=$(pwd)
list=$(cat temp.txt)

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


for pictures in $list; do 
	cur_picture=$(echo $pictures | cut -d . -f 1)
	cur_cat=$(echo ${pictures} | cut -d , -f 2)
	for angle in ${angles[@]}; do 
		echo "${cur_picture}_rot_${angle}.tif ${cur_cat}" >> rotate_${name}_temp.txt
	done
done

cat rotate_${name}_temp.txt | sort >> rotate_${name}
rm rotate_${name}_temp.txt
rm temp.txt
