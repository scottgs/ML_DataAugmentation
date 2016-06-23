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

rm ./bridge/bridge18.jpg
mv ./bridge/bridge51.jpg ./bridge/bridge18.jpg
rm ./port/port02.jpg
mv ./port/port51.jpg ./port/port02.jpg
rm ./port/port09.jpg
mv ./port/port52.jpg ./port/port09.jpg
convert ./railwaystation/railwaystation31.jpg -crop 600x600+0+0 +repage ./railwaystation/railwaystation31.tif
rm ./railwaystation/railwaystation31.jpg
