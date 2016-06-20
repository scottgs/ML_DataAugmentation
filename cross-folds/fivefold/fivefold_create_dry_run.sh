#!/bin/bash

# turns configs into databases and generates mean files

# tenfold scripts are of the form:
# IDENTIFIER_tenfold_{A..J}_{train,test}.txt

# DRY RUN VERSION BECAUSE THIS SCRIPT TAKES FOREVER AND THESE FILES ARE BIG

if test "$#" -ne 3; then
	echo "Bad param count! $0 <identifier> <path_to_data> <path_to_caffe_root>"
	exit 1
fi

echo '#!/bin/bash'
echo '# FIVEFOLD CREATE WOOOOOO'
#echo "$0"' <identifier> <path_to_data> <path_to_caffe_root>'
#echo "$0 $1 $2"

echo 'cd '"$(pwd)"

# MEAN EXAMPLE
# ../../caffe/build/tools/compute_image_mean -backend=lmdb 20_original_training_set 20_original_training.binaryproto
# DB CREATE EXAMPLE
#../../caffe/build/tools/convert_imageset -backend=lmdb -check_size -shuffle original/ 20_original_testingList.txt 20_original_testing_set &

# scrape a list of identifier matching files, sort them if theya aren't. SORTING IS IMPORTANT!
# loop by 2s throgh number of found files (better be 20!)
# pass the first (testing) to a background lmdb create
# pass the second to a foreground lmdb create
# background a mean computation, go to next loop

# UGH REGEX "./${1}"'_tenfold_[A-J]_(test|train).txt'
# refuses to work because, well, find probably doesn't actually support ()
# So I'll just validate the front part, because I'm tired of fighting it

files=($(set -f;find . -maxdepth 1 -type f -regex ./${1}_fivefold_[A-E]_.*.txt | cut -d / -f 2 | sort))
# entries SHOULD be ordered A test, A train, B test, B train, ...
# because {0..((${#files[@]} - 1))..2} is gross and doesn't actually work, I'm hardcoding it
# DEAL.
# but i'll sanity-check it
if test "${#files[@]}" -ne 10; then
	echo "Fivefold missing files? Found:"
	echo "${files[@]}"
	exit 1
fi

for file_idx in {0..9..2}; do
	(
		echo '('
		echo "${3}"'/build/tools/convert_imageset -backend=lmdb -check_size -shuffle '"${2} ${files[${file_idx}]} ${files[${file_idx}]%.txt}"
		echo 'mv '"${files[${file_idx}]} ${files[${file_idx}]%.txt}/"

		((file_idx++))

		echo "${3}"'/build/tools/convert_imageset -backend=lmdb -check_size -shuffle '"${2} ${files[${file_idx}]} ${files[${file_idx}]%.txt}"
		echo 'mv '"${files[${file_idx}]} ${files[${file_idx}]%.txt}/"

		echo "${3}"'/build/tools/compute_image_mean -backend=lmdb '"${files[${file_idx}]%.txt} ${files[${file_idx}]%.txt}.binaryproto"
		echo ')&'
	)
done

echo 'wait'
