#!/bin/bash

# averages logs in the current directory and puts it in the desired file

if test "$#" -ne 1; then
	echo "Bad param count! $0 <new_log_name>"
	exit 1
fi

files=$(find . -type f -name "*_test_stats.csv" -exec basename {} \;)

echo ${files} | sed 's/ /,/g' > ${1}

ex_file=$(find . -type f -name "*_test_stats.csv" | head -n 1)

sed -n '2p' ${ex_file} >> ${1}

tail -n+3 ${ex_file} | cut -d ',' -f 1 > tmp_log_itr

awk -F, '{a[FNR]+=$2;b[FNR]++;}END{for(i=3;i<=FNR;i++)print a[i]/b[i];}' *_test_stats.csv > tmp_log_accuracy

awk -F, '{a[FNR]+=$3;b[FNR]++;}END{for(i=3;i<=FNR;i++)print a[i]/b[i];}' *_test_stats.csv > tmp_log_test_loss

awk -F, '{a[FNR]+=$4;b[FNR]++;}END{for(i=3;i<=FNR;i++)print a[i]/b[i];}' *_test_stats.csv > tmp_log_train_loss

paste -d ',' tmp_log_itr tmp_log_accuracy tmp_log_test_loss tmp_log_train_loss >> ${1}

rm tmp_log_itr tmp_log_accuracy tmp_log_test_loss tmp_log_train_loss
