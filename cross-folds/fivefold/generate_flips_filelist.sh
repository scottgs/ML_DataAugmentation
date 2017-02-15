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


for pictures in $list; do 
	cur_picture=$(echo $pictures | cut -d . -f 1)
	cur_cat=$(echo ${pictures} | cut -d , -f 2)
	for i in flip_n.tif flip_v.tif; do 
		echo "${cur_picture}_${i} ${cur_cat}" >> flips_${name}_temp.txt
	done
done

cat flips_${name}_temp.txt | sort >> flips_${name}
rm flips_${name}_temp.txt
rm temp.txt
