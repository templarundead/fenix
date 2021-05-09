#!/usr/bin/env bash

array=(*.sh .bashrc)
for i in "${array[@]}";
do if [[ ! -f "$i" ]];
	then  echo -e "$(tput setaf 9;)No shellscripts found!$(tput sgr0;)"
	else
		beautysh -t "$i";
	fi
done
exit