#!/bin/bash

if [ "$#" -ne 1 ]; then
	echo "Bad param count! $0 <accuracy_file>"
	exit 1
fi

results=$(tail -n +2 $1 | awk -F, '{a[$2]+=$3}END{for(i=0;i<21;++i) printf "%d: %d\n",i+1,a[i]}')
echo "${results}"
echo $(echo "${results}" | awk 'BEGIN{a=0}{a+=$2}END{printf "Total correct: %d",a}')

