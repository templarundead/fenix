#!/usr/bin/env bash

START=$(date +%s.%N)
#NAME=(*.svg)
echo -e "\e[0;5mStarting...\e[0m"
for i in *.svg;
do svgo "$i"
	END=$(date +%s.%N)
	# разница
	DIFF=`echo "$END-$START" | bc -l`
	TIME=`echo "scale=2;($DIFF)/1"| bc -l`
	# итак:
	FILESIZEINGB=$(du -h "${i[@]}" | awk '{print $1}')
	echo -e "\e[0;94mTime\e[0m": "$TIME" "sec"
	echo -e "\e[0;94mName\e[0m": "${i[@]}"
	echo -e "\e[0;94mSize\e[0m": "$FILESIZEINGB"

done
exit