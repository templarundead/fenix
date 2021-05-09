#!/usr/bin/env bash

START=$(date +%s.%N)
FILE=sandbox/main.js
NAME=$(grep -Po "(?<=require\(')[^']+(?=')" $FILE)
echo -e "\e[0;5mStarting...\e[0m"
for i in $FILE
do browserify -p tinyify "$FILE" -o /tmp/"$NAME".js
	END=$(date +%s.%N)
	# разница
	DIFF=$(echo "$END-$START" | bc -l)
	TIME=$(echo "scale=2;($DIFF)/1"| bc -l)
	# итак:
	FILESIZEINGB=$(du -h /tmp/"$NAME.js" | awk '{print $1}')
	echo -e "\e[0;94mTime\e[0m": "$TIME" "sec"
	echo -e "\e[0;94mName\e[0m": "$NAME".js
	echo -e "\e[0;94mSize\e[0m": "$FILESIZEINGB"
done
exit