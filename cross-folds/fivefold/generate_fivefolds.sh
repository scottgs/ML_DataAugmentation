#!/bin/bash

if test "$#" -ne 1; then
	echo "Bad param count! $0 <src_dir>"
	exit 1
fi


if [ -d Fivefolds/ ]; then

	echo "Using the existing fivefolds."

fi

if [ ! -d Fivefolds ]; then
	src_dr=$1
	cat_list=$(ls $1)

	for cat in $cat_list; do 

		files=$(find $src_dr/$cat/ -type f | shuf)


		#echo -e $1
		#echo $files | tr ' ' '\n' > temp.txt
		echo $files | tr ' ' '\n' | rev | cut -d '/' -f 1,2 | rev > temp.txt

		fold=5
		num=$(wc -l temp.txt | cut -d " " -f 1)

		let per=$num/$fold

		split -l $per temp.txt partition

		if [ -f partitionaf ]; then
			cat partitionaf >> partitionae
			rm partitionaf
		fi

		for idx in a b c d e; do
			sort partitiona${idx} >> partition_${idx}.txt
			rm partitiona${idx}
		done

		rm temp.txt

	done

	for i in {0..4..1}; do
	 	folds=(A B C D E);
	 	vars=(a b c d e);
		cat partition_${vars[$i]}.txt >> fivefold_${folds[$i]}_test.txt
		unset vars[$i]
		vars=("${vars[@]}")
		for j in {0..3..1}; do
			files=$(cat partition_${vars[$j]}.txt)
			cat partition_${vars[$j]}.txt >> temp.txt
		done

		sort temp.txt >> fivefold_${folds[$i]}_train.txt
		rm temp.txt
	done

	mkdir Partitions
	mv partition_* Partitions

	mkdir Fivefolds
	mv fivefold_*_*.txt Fivefolds/
fi
