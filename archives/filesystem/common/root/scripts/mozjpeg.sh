#!/usr/bin/env bash

name=(*.jpg)
oldfilesize=$(du -h "$name" | awk '{print $1}')
start=$(date +%s.%N)
for f in `find . -name "${name[@]}"`
do jpegtran-static -copy none -outfile "$f" "$f"
	end=$(date +%s.%N)
	# разница
	diff=$(echo "$end-$start" | bc -l)
	time=$(echo "scale=2;($diff)/1"| bc -l)
	# итак:
	filesize=$(du -h "$f" | awk '{print $1}')
	echo -e "\e[0;94mTime\e[0m": "$time" "sec"
	echo -e "\e[0;94mName\e[0m": "${f[*]}"
	echo -e "\e[0;94mOld size\e[0m": "$oldfilesize"
	echo -e "\e[0;94mNew size\e[0m": "$filesize"

	#if [[ ! -f "${f[@]}" ]];

	#then  echo -e "\e[0;31mNo images found!\e[0m"

	#fi
	#exit

done
exit