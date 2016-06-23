#!/bin/bash
# bash 4+ actually

if test "$#" -ne 1; then
	echo "Bad param count! $0 <path_to_dataset>"
	exit 1
fi

cd $1

# this dataset was formatted by children and I'm not putting more energy into fixing it

for dir in $(find . -type d); do
	mv $dir ${dir,,}
done

for file in $(find . -type f); do
	mv $file ${file//-/}
done

for file in $(find . -type f); do
	mv $file ${file//_/}
done

for file in $(find . -type f); do
	mv $file ${file,,}
done

rm /home/richard/DataSets/RSDataset/bridge/bridge18.jpg
rm /home/richard/DataSets/RSDataset/port/port02.jpg
rm /home/richard/DataSets/RSDataset/port/port09.jpg
rm /home/richard/DataSets/RSDataset/railwaystation/railwaystation31.jpg
