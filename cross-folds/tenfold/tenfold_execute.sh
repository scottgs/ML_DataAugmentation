#!/bin/bash

# copies the template
# find/replace the paths with the needed plan id files
# execute it with the specified gpu(s)
# move the finished network somewhere else (. to disable I guess)

if test "$#" -ne 7; then
	echo "Bad param count! $0 <template_path> <weights> <plan_dir> <plan_identifier> <gpus> <finished_dst> <caffe_root>"
	exit 1
fi

# example ../../caffe/build/tools/caffe train -solver solver.prototxt -weights ../bvlc_reference_caffenet.caffemodel -gpu 1

#gotta execute from within the template, so abs paths for... everything?

template=${1%/}
template_name=$(basename $template)
weight_file=$2
plan_dir=$3
plan_id=$4
gpu_sel=$5
relocation=$6
caffe=$7

work_dir=$(pwd)

files=($(find ${plan_dir} -maxdepth 1 -name ${plan_id}_tenfold_?_\* | sort))

# should be like this:
#./cropped_tenfold_F_test
#./cropped_tenfold_F_train
#./cropped_tenfold_F_train.binaryproto

if test "${#files[@]}" -ne 30; then
	echo "Bad file total, should be 30? Got:"
	echo "${files[@]}"
	exit 1
fi

# Once again, hardcoding because ugh
for i in {0..29..3}; do
	# Meanfile set to MEANFILE_PATH for find/replace
	# Training data path set to TRAINING_DATA_PATH for find/replace
	# Testing data path set to TESTING_DATA_PATH for find/replace
	# everything's in the train_val.prototxt
	(
		dirname=$(basename ${files[$i]})
		dirname=${dirname::-5}
		dirname+="_"
		dirname+=${template_name}

		cp -r ${template} ${dirname}

		cd ${dirname}

		A=${files[$i]}
		B=${files[((i + 1))]}
		C=${files[((i + 2))]}

		sed -i -e "s|MEANFILE_PATH|${C}|g" -e "s|TRAINING_DATA_PATH|${B}|g" \
			-e "s|TESTING_DATA_PATH|${A}|g" train_val.prototxt
		sed -i -e "s|MEANFILE_PATH|${C}|g" extract.prototxt

		# template filled out? Woo?

		echo "${caffe}/build/tools/caffe train -solver solver.prototxt -weights ${weight_file} -gpu ${gpu_sel}"
		echo "Logging to "$(pwd)"/${dirname}_log.txt"
		${caffe}/build/tools/caffe train -solver solver.prototxt -weights ${weight_file} -gpu ${gpu_sel} &> ${dirname}_log.txt

		echo "Relocating data!"
		cd ..
		mv ${dirname} ${relocation}/
	)

done
