#!/usr/bin/env bash

START=$(date +%s.%N)
echo -e $(tput setaf 103;)Enter TMP directory$(tput sgr0;)
cd ../tmp || exit

archive=(*.xz *.img)
if [[ -f "$archive" ]];
then echo -e $(tput setaf 9;)Directory have an old archives!$(tput sgr0;)
	rm "$archive"
	echo -e $(tput setaf 103;)Removing an old archives$(tput sgr0;)
fi

echo -e $(tput setaf 103;)Unpacking zip archive$(tput sgr0;)
for i in *.zip
do unzip -q "$i" && rm "$i";
done

echo -e $(tput setaf 103;)Unpacking xz archive$(tput sgr0;)
for i in *.xz;
do pixz -d -p 6 "$i"
done

for i in *.img;
do if ( lsblk | grep -q 'sdb' );
	then
		echo -e $(tput setaf 103;)Write image to...$(tput sgr0;);
		dd if=/tmp/"$i" of=/dev/sdb bs=512K status=progress && rm "$i";
	else
		echo -e $(tput setaf 103;)Please insert SD Card$(tput sgr0;);
	fi
	exit

	END=$(date +%s.%N)

	# difference
	DIFF=$(echo "$END-$START" | bc -l)
	TIME=$(echo "scale=2;($DIFF)/1"| bc -l)

	# result
	echo -e "\e[0;94mTime\e[0m": "$TIME" "sec"

done
exit