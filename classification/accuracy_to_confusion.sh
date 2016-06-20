#!/bin/bash

if [ "$#" -ne 1 ]; then
	echo "Bad param count! $0 <accuracy_file>"
	exit 1
fi

tail -n +2 $1 | awk -F, '{a[$2][$5]+=1}END{for(i=0;i<21;++i) {for(j=0;j<21;++j) {printf "%1.2f",a[i][j]/100.0; if(j!=20) printf ","} printf "\n"}}'
