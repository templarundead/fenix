#!/usr/bin/env bash

for c in {1..256}

do
	echo -en "\r" "$(tput setaf ${c})"LOVE IS DEAD "$c" "$(tput sgr0;)" "\n"
done