if test "$#" -ne 2; then
	echo "Bad param count! $0 <path_to_dataset> <stats_script>"
	exit 1
fi

count=$(find $1 -type f | wc -l)

find $1 -type f -exec sh -c "identify -verbose {} | fgrep entropy | tail -n 1 | awk '{print \$2}'" \; | pv -l -s ${count} | $2
