#!/bin/bash
# Log processor

if test "$#" -ne 1; then
	echo "Bad param count! $0 <log>"
	exit 1
fi

base_name=$(basename $1)
base_name=${base_name%.txt}

# Eh, this log is boring, and more files to manage

#fgrep -v Snapshotting ${1} > ${base_name}_cleaned.txt

#fgrep 'sgd_solver.cpp:106]' ${1} | awk '{print $6}' | cut -d ',' -f 1 > ${base_name}_iterations.txt

#fgrep 'sgd_solver.cpp:106]' ${1} |  awk '{print $9}' > ${base_name}_learn_rate.txt

#fgrep 'solver.cpp:253]' ${1} | awk '{print $11}' > ${base_name}_train_loss.txt

#echo "${base_name}" > ${base_name}_itr_stats.csv
#echo "itr,learning_rate,train_loss" >> ${base_name}_itr_stats.csv

#paste -d ',' ${base_name}_iterations.txt ${base_name}_learn_rate.txt ${base_name}_train_loss.txt >> ${base_name}_itr_stats.csv

#rm ${base_name}_iterations.txt ${base_name}_learn_rate.txt ${base_name}_train_loss.txt

#
##
#

fgrep 'solver.cpp:341]' ${1} | awk '{print $6}' | cut -d ',' -f 1 > ${base_name}_test_iterations.txt

fgrep 'solver.cpp:409]' ${1} > ${base_name}_tmp.txt

fgrep 'accuracy' ${base_name}_tmp.txt | awk '{print $11}' > ${base_name}_test_accuracy.txt

fgrep 'loss' ${base_name}_tmp.txt | awk '{print $11}' > ${base_name}_test_loss.txt

fgrep 'Testing net' E.txt -B 1 -A 3 | fgrep 'Iteration' | fgrep 'loss' | awk '{print $9}' > ${base_name}_train_loss.txt

rm ${base_name}_tmp.txt

echo "${base_name}" > ${base_name}_test_stats.csv
echo "itr,accuracy,test_loss,train_loss" >> ${base_name}_test_stats.csv
paste -d ',' ${base_name}_test_iterations.txt ${base_name}_test_accuracy.txt ${base_name}_test_loss.txt ${base_name}_train_loss.txt >> ${base_name}_test_stats.csv

rm ${base_name}_test_iterations.txt ${base_name}_test_accuracy.txt ${base_name}_test_loss.txt ${base_name}_train_loss.txt

