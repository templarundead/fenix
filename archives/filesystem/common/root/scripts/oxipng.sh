#!/usr/bin/env bash

start=$(date +%s.%N)
name=(*.png)
if [[ ! -f "$name" ]];
then  echo -e "\e[0;31mNo images found!\e[0m"
else
	oxipng -o 6 --strip all *.png
	end=$(date +%s.%N)
	# разница
	diff=$(echo "$end-$start" | bc -l)
	time=$(echo "scale=2;($diff)/1"| bc -l)
	# итак:
	filesize=$(du -h "$name" | awk '{print $1}')
	echo -e "\e[0;94mTime\e[0m": "$time" "sec"
	echo -e "\e[0;94mName\e[0m": "${name[*]}"
	echo -e "\e[0;94mSize\e[0m": "$filesize"

fi
exit
exit
