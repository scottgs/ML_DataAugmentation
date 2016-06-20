#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "Bad param count! $0 <filename> <new_cutoff>"
	exit 1
fi

awk -F, -v cutoff=${2} '
{
if (FNR == 1)
	{
		printf "%s,%s,%s,%s,%s\n",$1,$2,$3,$4,$5;
	} else {
		a = ($4 > cutoff && $2 == $5) ? 1:0;
		printf "%s,%d,%d,%.4f,%d\n",$1,$2,a,$4,$5;
	}
}' $1
