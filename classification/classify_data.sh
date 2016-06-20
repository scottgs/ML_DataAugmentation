#!/bin/bash

if [ "$#" -ne 8 ]; then
	echo "Bad param count! $0 <plan_dir> <plan_id> <network_root> <network_id> <classifier_bin> <img_root> <gpu> <filename>"
	exit 1
fi


# Alrighty, we need to first take the plan info and find the testing labelings
# as those will be out files we feed to that network (A-E, or more if I can be generic enough)

# We take those labelings and, idk, strip it to be a file list (cut firt column on spaces)

# Loop though that aggregating results into a file (or to a var for processing)

plan_dir=$1
plan_id=$2
network_root=$3
network_id=$4
exe=$5
imgs=$6
gpu=$7

# output of classification exe is:
# ANNOYING LINE
# %accuracy - "label"
# with a single space between. Capture to array? (pipe to tail first)

# Oh no! Plan id might not lign up with everything correctly
# Since we ALWAYS want the cropped plans but we then apply it to augmented networks

# so we'll take in network and plan ids

# ideally, networks of different plans will be in their own subdirs, which is what we do
# but we'll use the IDs to be extra safe. We technically could assume subdirs and just use everything we find

# /* on path to prevent it from picking up parent path if it has the id in the title
plan_paths=($(find ${plan_dir}/* -maxdepth 0 -type d -name ${plan_id}\*test | sort))
# should come back with something like:
# .../cropped_fivefold_A_test
# .../cropped_fivefold_B_test
# .../cropped_fivefold_C_test
# .../cropped_fivefold_D_test
# .../cropped_fivefold_E_test

#echo "PATHS FOUND:"
#echo ${plan_paths[@]}
#read

network_paths=($(find ${network_root}/* -type d -name ${network_id}\* | sort))
# should be same as plan_paths, but different id
if [ "${#plan_paths[@]}" -ne "${#network_paths[@]}" ]; then
	echo "Plan count != network count!!!"
	echo "PLANS: ${plan_paths[@]}"
	echo "NETWORKS: ${network_paths[@]}"
	exit 1
fi
# we are going to assume networks and plans line up when sorted (A -> A, and so on)

# meanfiles can be found by appending ".binaryproto" to the result
# since meanfiles exist alongsize the plan since it's shared between test and train

# category array, in recieved order, index should be catid as well
# (order should be alpha because other scripts make it so)
# (but if it somehow isn't, we'll use whatever order is in the file
plan_name=$(basename ${plan_paths[0]})
# each plan will have a full list of cats
cat_list=($(cat ${plan_paths[0]}/${plan_name}.txt | cut -d ' ' -f 1 | cut -d '/' -f 1 | uniq))

#echo "CATS FOUND:"
#echo ${cat_list[@]}
#read

# so let's generate a mapping file of class number to class name first
# and make a dummy labeling for the classifier app
base_fname="${8}"
label_fname="${base_fname}_labels.csv"

echo "id,name" > ${label_fname}
for i in "${!cat_list[@]}"; do
	echo "${i},${cat_list[$i]}" >> ${label_fname}
done

# so we want output that looks kinda like
# file_name given_class correct probability reported_class
# string,id,bool,double,id
# where a classification is considered "correct" if it's probability is over .5 and the same id as expected

# we should be ready to start working?
# we can use an fgrep of " $plan_id_num" | cut -d ' ' -f 1 to get all files for cat x

# file will be a little out of order with reguards to alpha orddering fo files
# maybe look into how to use sort with cut to sort on col 1 when done

# LET'S GO!
output_fname="${base_fname}_accuracy.csv"
echo "fname,class_id,correct,probability,reported_class" > ${output_fname}


for plan_num in "${!plan_paths[@]}"; do
	plan_name=$(basename ${plan_paths[${plan_num}]})
	#proto_path="${plan_paths[${plan_num}]}.binaryproto"
	# could just cat the test label file to an array
	# but I'm going to stick with grep because it's more explicit
	# and I don't want to deal with weird indexing

	# select whatever network was the latest for testing. ...outputiing it in case this is bad (file copy)
	sel_network=$(ls -t ${network_paths[${plan_num}]}/snaps/*.caffemodel | head -n 1)
	echo "FYI, using network: ${sel_network}"


	# Classifier is better! Woo! Just pass it the test file and it'll process it!

	fcount=$(wc -l ${plan_paths[${plan_num}]}/${plan_name}.txt | cut -d ' ' -f 1)

	${exe} ${network_paths[${plan_num}]}/deploy.prototxt ${sel_network} ${plan_dir}/${plan_name::-4}train.binaryproto ${plan_paths[${plan_num}]}/${plan_name}.txt ${imgs} ${gpu} | pv -l -s ${fcount} | awk -F, '{if (FNR > 1) printf "%s,%d,%d,%.4f,%d\n",$1, $2, (($3 > 0.5 && $2 == $4) ? 1 : 0), $3, $4}' >> ${output_fname}



#	for class_id in "${!cat_list[@]}"; do
#		# array of all files of specified cat in the selected set
#		file_list=($(fgrep "${cat_list[${class_id}]}" ${plan_paths[${plan_num}]}/${plan_name}.txt | cut -d ' ' -f 1))
#
#		for test_file in "${file_list[@]}"; do
#			#echo "${exe} ${network_paths[${plan_num}]}/deploy.prototxt ${sel_network} ${plan_dir}/${plan_name::-4}train.binaryproto ${dummy_fname} ${imgs}/${test_file} 1 ${gpu}"
#			#echo
#			result=($(${exe} ${network_paths[${plan_num}]}/deploy.prototxt ${sel_network} ${plan_dir}/${plan_name::-4}train.binaryproto ${dummy_fname} ${imgs}/${test_file} 1 ${gpu} | tail -n 1))
#			# Well that's a fun command, hope it' right. (it wasn't)
#			#echo "GOT: ${result[@]}"
#			result_str="${test_file},${class_id},"
#			if (( $(echo "${result[0]} > 0.5" | bc -l)  )) && (( ${result[2]:1:-1} == ${class_id} )) ; then
#				result_str+="1,"
#			else
#				result_str+="0,"
#			fi
#			result_str+="${result[0]},${result[2]:1:-1}"
#			echo ${result_str} >> ${output_fname}
#			echo ${result_str}
#			#read
#		done
#	done
done

